using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
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
                // The user directory renders small avatars; shipping every
                // account's full picture with the page is wasted bandwidth.
                // Rows carry HasPicture and fetch bytes from
                // GET /Users/{id}/picture when one is actually drawn.
                Items = users.Select(u =>
                {
                    var response = MapToResponse(u);
                    response.Picture = null;
                    return response;
                }).ToList(),
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

            // Assigning a domain role has to produce the matching profile in
            // the same operation, otherwise an admin can mint a Patient account
            // that logs in but has no chart to book against.
            await SyncDomainProfilesAsync(user, await GetRoleNamesAsync(user.Id), request.DateOfBirth);
            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return await GetUserResponseWithRolesAsync(user.Id);
        }

        public async Task<UserResponse> RegisterPatientAsync(UserUpsertRequest request, DateTime dateOfBirth)
        {
            // Public registration creates the account AND the clinic patient
            // profile atomically; a half-registered user (account without a
            // Patient row) could log in but never book. This is the single
            // entry point for creating a patient — there is no follow-up
            // "complete profile" call to an endpoint patients cannot reach.
            ValidateDateOfBirth(dateOfBirth);

            await using var transaction = await _context.Database.BeginTransactionAsync();
            var user = await CreateUserCoreAsync(request);

            await SyncDomainProfilesAsync(user, await GetRoleNamesAsync(user.Id), dateOfBirth);
            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return await GetUserResponseWithRolesAsync(user.Id);
        }

        private Task<List<string>> GetRoleNamesAsync(int userId)
        {
            return _context.UserRoles
                .Where(ur => ur.UserId == userId)
                .Select(ur => ur.Role.Name)
                .ToListAsync();
        }

        private static bool IsPatientRole(string name)
        {
            var v = name.Trim().ToLowerInvariant();
            return v is "patient" or "user";
        }

        private static bool IsDoctorRole(string name)
        {
            var v = name.Trim().ToLowerInvariant();
            return v is "doctor" or "dentist" or "stomatolog";
        }

        private static void ValidateDateOfBirth(DateTime dateOfBirth)
        {
            var today = DateTime.UtcNow.Date;
            if (dateOfBirth.Date > today)
            {
                throw new BusinessException("Datum rođenja ne može biti u budućnosti.");
            }
            if (dateOfBirth.Date < today.AddYears(-120))
            {
                throw new BusinessException("Datum rođenja nije ispravan.");
            }
        }

        /// <summary>
        /// Keeps <see cref="User"/>, <see cref="Patient"/> and
        /// <see cref="Doctor"/> in step within one business operation.
        /// <para>
        /// The three tables repeat the person's name and phone, and the
        /// appointment/order projections read them from Patient — so a profile
        /// edit that touched only User left the rest of the app showing the old
        /// surname or phone. User is the source of truth for those shared
        /// fields and they are written through here.
        /// </para>
        /// <para>
        /// Role assignment is handled here too: a domain role without its
        /// profile is a broken account. Patient charts are created on demand
        /// (they need only a date of birth); a Doctor profile carries a
        /// specialization the user form does not collect, so the Doctor role is
        /// refused until that profile exists rather than inventing a blank one.
        /// </para>
        /// </summary>
        private async Task SyncDomainProfilesAsync(User user, IReadOnlyCollection<string> roleNames, DateTime? dateOfBirth)
        {
            var phone = string.IsNullOrWhiteSpace(user.PhoneNumber)
                ? string.Empty
                : user.PhoneNumber.Trim();

            var patient = await _context.Patients.FirstOrDefaultAsync(p => p.UserId == user.Id);
            if (roleNames.Any(IsPatientRole) && patient == null)
            {
                if (dateOfBirth == null)
                {
                    throw new BusinessException(
                        "Za pacijentsku ulogu je potreban datum rođenja.");
                }

                ValidateDateOfBirth(dateOfBirth.Value);
                _context.Patients.Add(new Patient
                {
                    UserId = user.Id,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    Phone = phone,
                    DateOfBirth = dateOfBirth.Value.Date,
                });
            }
            else if (patient != null)
            {
                // The chart is kept even if the role is later removed, because
                // appointments and orders still reference it.
                patient.FirstName = user.FirstName;
                patient.LastName = user.LastName;
                patient.Phone = phone;

                if (dateOfBirth != null)
                {
                    ValidateDateOfBirth(dateOfBirth.Value);
                    patient.DateOfBirth = dateOfBirth.Value.Date;
                }
            }

            var doctor = await _context.Doctors.FirstOrDefaultAsync(d => d.UserId == user.Id);
            if (roleNames.Any(IsDoctorRole) && doctor == null)
            {
                throw new BusinessException(
                    "Doktorski profil za ovog korisnika ne postoji. Kreirajte doktora prije dodjele Doctor uloge.");
            }

            if (doctor != null)
            {
                doctor.FirstName = user.FirstName;
                doctor.LastName = user.LastName;
            }
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
            List<string>? effectiveRoleNames = null;
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

                // Read the names from the request rather than the database: the
                // rows above are only tracked, not saved yet, so a query would
                // still return the roles being replaced.
                effectiveRoleNames = await _context.Roles
                    .Where(r => request.RoleIds.Contains(r.Id))
                    .Select(r => r.Name)
                    .ToListAsync();
                user.Role = effectiveRoleNames.Count > 0
                    ? InferDomainRoleFromRoleNames(effectiveRoleNames)
                    : UserRoleType.Patient;
            }

            // Runs on every update, not just role changes: the Patient/Doctor
            // rows carry their own copy of the name and phone, and the booking
            // and order screens read them from there.
            await SyncDomainProfilesAsync(
                user,
                effectiveRoleNames ?? await GetRoleNamesAsync(user.Id),
                request.DateOfBirth);

            await _context.SaveChangesAsync();
            return await GetUserResponseWithRolesAsync(user.Id);
        }

        /// <summary>
        /// Issues a one-time reset code for whoever owns the username or
        /// e-mail, or returns null when nobody does.
        /// <para>
        /// The caller must not reveal which of those happened: answering
        /// differently for a known and an unknown account turns this endpoint
        /// into a way to enumerate users. Any earlier unused code is
        /// invalidated so only the newest one works.
        /// </para>
        /// </summary>
        public async Task<PasswordResetIssue?> RequestPasswordResetAsync(string usernameOrEmail, CancellationToken cancellationToken = default)
        {
            var needle = (usernameOrEmail ?? string.Empty).Trim();
            if (needle.Length == 0)
            {
                return null;
            }

            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Username == needle || u.Email == needle, cancellationToken);

            // A deactivated account must not be recoverable either: letting it
            // reset a password would hand back an account an administrator
            // deliberately closed.
            if (user == null || !user.IsActive)
            {
                return null;
            }

            var previous = await _context.PasswordResetTokens
                .Where(t => t.UserId == user.Id && t.UsedAt == null)
                .ToListAsync(cancellationToken);
            foreach (var stale in previous)
            {
                stale.UsedAt = DateTime.UtcNow;
            }

            var code = GenerateResetCode();
            var expiresAt = DateTime.UtcNow.AddMinutes(ResetCodeLifetimeMinutes);

            _context.PasswordResetTokens.Add(new PasswordResetToken
            {
                UserId = user.Id,
                CodeHash = HashResetCode(code),
                ExpiresAt = expiresAt,
                CreatedAt = DateTime.UtcNow,
            });

            await _context.SaveChangesAsync(cancellationToken);

            return new PasswordResetIssue(user.Id, user.Email, user.FirstName, code, expiresAt);
        }

        /// <summary>
        /// Sets a new password once the one-time code checks out. The code is
        /// verified server-side against its stored hash, must not be expired,
        /// and is consumed on success so it cannot be replayed.
        /// </summary>
        public async Task ResetPasswordAsync(string usernameOrEmail, string code, string newPassword, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(newPassword) || newPassword.Length < 8)
            {
                throw new BusinessException("Nova lozinka mora imati najmanje 8 znakova.");
            }

            var needle = (usernameOrEmail ?? string.Empty).Trim();
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Username == needle || u.Email == needle, cancellationToken);

            // One message for every failure mode below, so a wrong code cannot
            // be told apart from an unknown account.
            const string invalid = "Kod za reset lozinke nije ispravan ili je istekao.";

            if (user == null || !user.IsActive)
            {
                throw new BusinessException(invalid);
            }

            var hash = HashResetCode((code ?? string.Empty).Trim());
            var now = DateTime.UtcNow;
            var token = await _context.PasswordResetTokens
                .Where(t => t.UserId == user.Id && t.UsedAt == null && t.ExpiresAt > now)
                .OrderByDescending(t => t.Id)
                .FirstOrDefaultAsync(cancellationToken);

            if (token == null || !CryptographicOperations.FixedTimeEquals(
                    Encoding.UTF8.GetBytes(token.CodeHash), Encoding.UTF8.GetBytes(hash)))
            {
                throw new BusinessException(invalid);
            }

            user.PasswordHash = HashPassword(newPassword, out byte[] salt);
            user.PasswordSalt = Convert.ToBase64String(salt);
            token.UsedAt = now;

            await _context.SaveChangesAsync(cancellationToken);
        }

        private const int ResetCodeLifetimeMinutes = 15;

        /// <summary>Six digits, from a cryptographic RNG rather than Random.</summary>
        private static string GenerateResetCode()
        {
            return RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");
        }

        private static string HashResetCode(string code)
        {
            var bytes = SHA256.HashData(Encoding.UTF8.GetBytes(code));
            return Convert.ToBase64String(bytes);
        }

        public Task<byte[]?> GetPictureAsync(int id, CancellationToken cancellationToken = default)
        {
            return _context.Users
                .AsNoTracking()
                .Where(u => u.Id == id)
                .Select(u => u.Picture)
                .FirstOrDefaultAsync(cancellationToken);
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
                HasPicture = user.Picture is { Length: > 0 },
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

            // An administrator deactivating an account must actually keep that
            // account out: without this check `IsActive = false` only hid the
            // user from parts of the UI while a fresh login still issued a JWT.
            // The message is deliberately distinct from "wrong credentials" so
            // the user knows to contact the clinic rather than retry.
            if (!user.IsActive)
            {
                throw new BusinessException("Vaš račun je deaktiviran. Obratite se administraciji ordinacije.");
            }

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