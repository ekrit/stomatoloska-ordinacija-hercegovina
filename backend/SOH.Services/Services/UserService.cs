using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using SOH.Model.Exceptions;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Model.Requests;
using MapsterMapper;
using SOH.Services.Database;
using SOH.Services.Helpers;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class UserService : BaseService<UserResponse, UserSearchObject, User>, IUserService
    {
        private const int SaltSize = 16;
        private const int KeySize = 32;
        private const int Iterations = 10000;

        private readonly ICurrentUserAccessor _currentUser;

        public UserService(SOHDbContext context, IMapper mapper, ICurrentUserAccessor currentUser) : base(context, mapper)
        {
            _currentUser = currentUser;
        }

        public override async Task<PagedResult<UserResponse>> GetAsync(UserSearchObject search)
        {
            var query = _context.Users.AsQueryable();

            if (!string.IsNullOrEmpty(search.Username))
            {
                query = query.Where(u => u.Username.Contains(search.Username));
            }

            if (!string.IsNullOrEmpty(search.Email))
            {
                query = query.Where(u => u.Email.Contains(search.Email));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(u =>
                    u.FirstName.Contains(search.FTS) ||
                    u.LastName.Contains(search.FTS) ||
                    u.Username.Contains(search.FTS) ||
                    u.Email.Contains(search.FTS));
            }

            if (search.GenderId.HasValue)
            {
                query = query.Where(u => u.GenderId == search.GenderId.Value);
            }

            if (search.CityId.HasValue)
            {
                query = query.Where(u => u.CityId == search.CityId.Value);
            }

            if (search.RoleId.HasValue)
            {
                query = query.Where(u => u.UserRoles.Any(ur => ur.RoleId == search.RoleId.Value));
            }

            query = query
                .Include(u => u.Gender)
                .Include(u => u.City)
                .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role);

            int? totalCount = null;
            if (search.IncludeTotalCount)
            {
                totalCount = await query.CountAsync();
            }

            // Clamp to the shared ceiling so /Users cannot be used to pull
            // the whole table in one request (consistent with BaseService).
            var pageSize = Math.Clamp(search.PageSize ?? 30, 1, MaxPageSize);
            var page = Math.Max(search.Page ?? 0, 0);
            query = query.Skip(page * pageSize).Take(pageSize);

            var users = await query.ToListAsync();
            return new PagedResult<UserResponse>
            {
                Items = users.Select(MapToResponse).ToList(),
                TotalCount = totalCount
            };
        }

        public override async Task<UserResponse?> GetByIdAsync(int id)
        {
            var user = await _context.Users
                .Include(u => u.Gender)
                .Include(u => u.City)
                .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
                return null;

            return MapToResponse(user);
        }

        private string HashPassword(string password, out byte[] salt)
        {
            salt = new byte[SaltSize];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations))
            {
                return Convert.ToBase64String(pbkdf2.GetBytes(KeySize));
            }
        }

        /// <summary>
        /// Aligns <see cref="User.Role"/> (domain type) with assigned JWT role names.
        /// </summary>
        private static UserRoleType InferDomainRoleFromRoleNames(IEnumerable<string> roleNames)
        {
            var set = new HashSet<string>(roleNames.Select(n => n.Trim().ToLowerInvariant()));
            if (set.Contains("administrator") || set.Contains("admin"))
                return UserRoleType.Admin;
            if (set.Contains("doctor") || set.Contains("dentist") || set.Contains("stomatolog"))
                return UserRoleType.Doctor;
            return UserRoleType.Patient;
        }

        public async Task<UserResponse> CreateAsync(UserUpsertRequest request)
        {
            // Two SaveChangesAsync calls (user, then roles + audit) must land
            // or fail together, so the whole operation runs in a transaction.
            await using var transaction = await _context.Database.BeginTransactionAsync();
            var user = await CreateUserCoreAsync(request);
            await transaction.CommitAsync();

            return await GetUserResponseWithRolesAsync(user.Id);
        }

        public async Task<UserResponse> RegisterPatientAsync(UserUpsertRequest request, DateTime? dateOfBirth)
        {
            // Public registration creates the account AND the clinic patient
            // profile atomically; a half-registered user (account without a
            // Patient row) could log in but never book.
            await using var transaction = await _context.Database.BeginTransactionAsync();
            var user = await CreateUserCoreAsync(request);

            _context.Patients.Add(new Patient
            {
                UserId = user.Id,
                FirstName = request.FirstName,
                LastName = request.LastName,
                Phone = string.IsNullOrWhiteSpace(request.PhoneNumber) ? string.Empty : request.PhoneNumber.Trim(),
                DateOfBirth = dateOfBirth ?? DateTime.UtcNow.Date
            });
            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return await GetUserResponseWithRolesAsync(user.Id);
        }

        private async Task<User> CreateUserCoreAsync(UserUpsertRequest request)
        {
            // Check if user with same email or username already exists
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                throw new BusinessException("Korisnik s ovom e-mail adresom već postoji.");
            }

            if (await _context.Users.AnyAsync(u => u.Username == request.Username))
            {
                throw new BusinessException("Korisnik s ovim korisničkim imenom već postoji.");
            }

            ImageValidator.Validate(request.Picture, nameof(request.Picture));

            var roleNamesForDomain = request.RoleIds != null && request.RoleIds.Any()
                ? await _context.Roles
                    .Where(r => request.RoleIds!.Contains(r.Id))
                    .Select(r => r.Name)
                    .ToListAsync()
                : new List<string>();

            var user = new User
            {
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                Username = request.Username,
                PhoneNumber = request.PhoneNumber,
                GenderId = request.GenderId,
                CityId = request.CityId,
                IsActive = request.IsActive,
                CreatedAt = DateTime.UtcNow,
                Picture = request.Picture,
                Role = roleNamesForDomain.Count > 0
                    ? InferDomainRoleFromRoleNames(roleNamesForDomain)
                    : UserRoleType.Patient
            };

            // Hash password if provided
            if (!string.IsNullOrEmpty(request.Password))
            {
                user.PasswordHash = HashPassword(request.Password, out byte[] salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            _context.ActivityLogs.Add(new ActivityLog
            {
                Action = "UserRegistered",
                EntityName = "User",
                EntityId = user.Id.ToString(),
                // Self-registration has no authenticated caller yet, so the
                // freshly created user is the actor.
                UserId = _currentUser.UserId ?? user.Id,
                Username = _currentUser.Username ?? user.Username,
                CreatedAt = DateTime.UtcNow
            });

            if (request.RoleIds != null && request.RoleIds.Any())
            {
                foreach (var roleId in request.RoleIds)
                {
                    var userRole = new UserRole
                    {
                        UserId = user.Id,
                        RoleId = roleId,
                        DateAssigned = DateTime.UtcNow
                    };
                    _context.UserRoles.Add(userRole);
                }
            }

            await _context.SaveChangesAsync();
            return user;
        }

        public async Task<UserResponse?> UpdateAsync(int id, UserUpsertRequest request, bool callerIsAdmin)
        {
            var user = await _context.Users
                .Include(u => u.UserRoles)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
                return null;

            // Check if email is being changed and if it already exists
            if (request.Email != user.Email && await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                throw new BusinessException("Korisnik s ovom e-mail adresom već postoji.");
            }

            // Check if username is being changed and if it already exists
            if (request.Username != user.Username && await _context.Users.AnyAsync(u => u.Username == request.Username))
            {
                throw new BusinessException("Korisnik s ovim korisničkim imenom već postoji.");
            }

            ImageValidator.Validate(request.Picture, nameof(request.Picture));

            user.FirstName = request.FirstName;
            user.LastName = request.LastName;
            user.Email = request.Email;
            user.Username = request.Username;
            user.PhoneNumber = request.PhoneNumber;
            user.GenderId = request.GenderId;
            user.CityId = request.CityId;

            // IsActive and RoleIds are admin-only knobs. Silently ignoring
            // them on non-admin calls is intentional: the patient/doctor UI
            // never exposes these fields, so the server treats stray values
            // as benign noise rather than a 4xx response.
            if (callerIsAdmin)
            {
                user.IsActive = request.IsActive;
            }

            if (request.Picture != null)
            {
                user.Picture = request.Picture;
            }

            // Update password if provided. When a user changes their own
            // password they must confirm the current one; an admin editing
            // another user does not (rubric section 4).
            if (!string.IsNullOrEmpty(request.Password))
            {
                if (!callerIsAdmin)
                {
                    if (string.IsNullOrEmpty(request.OldPassword))
                    {
                        throw new BusinessException("Unesite trenutnu lozinku da biste je promijenili.");
                    }
                    if (!VerifyPassword(request.OldPassword, user.PasswordHash, user.PasswordSalt))
                    {
                        throw new BusinessException("Trenutna lozinka nije ispravna.");
                    }
                }

                user.PasswordHash = HashPassword(request.Password, out byte[] salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }

            // Update roles only when an admin asked for it.
            if (callerIsAdmin && request.RoleIds != null)
            {
                // Remove existing roles
                _context.UserRoles.RemoveRange(user.UserRoles);

                // Add new roles
                foreach (var roleId in request.RoleIds)
                {
                    var userRole = new UserRole
                    {
                        UserId = user.Id,
                        RoleId = roleId,
                        DateAssigned = DateTime.UtcNow
                    };
                    _context.UserRoles.Add(userRole);
                }

                var names = await _context.Roles
                    .Where(r => request.RoleIds.Contains(r.Id))
                    .Select(r => r.Name)
                    .ToListAsync();
                user.Role = names.Count > 0
                    ? InferDomainRoleFromRoleNames(names)
                    : UserRoleType.Patient;
            }

            await _context.SaveChangesAsync();
            return await GetUserResponseWithRolesAsync(user.Id);
        }

        public async Task ChangeOwnPasswordAsync(int userId, string oldPassword, string newPassword)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == userId)
                ?? throw new NotFoundException("Korisnik nije pronađen.");

            if (string.IsNullOrEmpty(oldPassword) ||
                !VerifyPassword(oldPassword, user.PasswordHash, user.PasswordSalt))
            {
                throw new BusinessException("Trenutna lozinka nije ispravna.");
            }

            if (string.IsNullOrEmpty(newPassword) || newPassword.Length < 4)
            {
                throw new BusinessException("Nova lozinka mora imati najmanje 4 znaka.");
            }

            user.PasswordHash = HashPassword(newPassword, out byte[] salt);
            user.PasswordSalt = Convert.ToBase64String(salt);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return false;

            // Block the delete while business records still reference the
            // account; a generic FK 500 would hide the reason from the admin.
            if (await _context.Appointments.AnyAsync(a => a.PatientId == id || a.DoctorId == id))
            {
                throw new BusinessException("Korisnik se ne može obrisati jer postoje termini koji ga koriste.");
            }

            if (await _context.Orders.AnyAsync(o => o.PatientId == id))
            {
                throw new BusinessException("Korisnik se ne može obrisati jer postoje narudžbe koje ga koriste.");
            }

            if (await _context.Reviews.AnyAsync(r => r.PatientId == id || r.DoctorId == id))
            {
                throw new BusinessException("Korisnik se ne može obrisati jer postoje recenzije koje ga koriste.");
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }

        protected override UserResponse MapToResponse(User user)
        {
            var response = new UserResponse
            {
                Id = user.Id,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Username = user.Username,
                Picture = user.Picture,
                IsActive = user.IsActive,
                CreatedAt = user.CreatedAt,
                LastLoginAt = user.LastLoginAt,
                PhoneNumber = user.PhoneNumber,
                GenderId = user.GenderId,
                GenderName = user.Gender?.Name ?? string.Empty,
                CityId = user.CityId,
                CityName = user.City?.Name ?? string.Empty,
                Roles = user.UserRoles?.Select(ur => new RoleResponse
                {
                    Id = ur.Role.Id,
                    Name = ur.Role.Name,
                    Description = ur.Role.Description
                }).ToList() ?? new List<RoleResponse>()
            };

            return response;
        }

        private async Task<UserResponse> GetUserResponseWithRolesAsync(int userId)
        {
            var user = await _context.Users
                .Include(u => u.Gender)
                .Include(u => u.City)
                .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.Id == userId);

            if (user == null)
                throw new NotFoundException("Korisnik nije pronađen.");

            return MapToResponse(user);
        }

        public async Task<UserResponse?> AuthenticateAsync(UserLoginRequest request)
        {
            var user = await _context.Users
                .Include(u => u.Gender)
                .Include(u => u.City)
                .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.Username == request.Username);

            if (user == null || !VerifyPassword(request.Password, user.PasswordHash, user.PasswordSalt))
                return null;

            // Update last login time
            user.LastLoginAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            return MapToResponse(user);
        }

        private bool VerifyPassword(string password, string passwordHash, string passwordSalt)
        {
            var salt = Convert.FromBase64String(passwordSalt);
            var hash = Convert.FromBase64String(passwordHash);
            using var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations);
            var hashBytes = pbkdf2.GetBytes(KeySize);
            return hash.SequenceEqual(hashBytes);
        }
    }
}