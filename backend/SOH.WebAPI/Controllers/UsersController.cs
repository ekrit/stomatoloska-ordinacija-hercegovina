using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using Microsoft.AspNetCore.Mvc;
using SOH.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Collections.Generic;
using SOH.WebAPI.Authorization;
using SOH.WebAPI.Services;

namespace SOH.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class UsersController : ControllerBase
    {
        private const string DefaultUserRoleName = RoleNames.Patient;
        private readonly IUserService _userService;
        private readonly IRoleService _roleService;
        private readonly IRevokedTokenStore _revokedTokens;
        private readonly IConfiguration _configuration;

        public UsersController(
            IUserService userService,
            IRoleService roleService,
            IRevokedTokenStore revokedTokens,
            IConfiguration configuration)
        {
            _userService = userService;
            _roleService = roleService;
            _revokedTokens = revokedTokens;
            _configuration = configuration;
        }

        private int? CurrentUserId =>
            int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : null;

        [HttpGet]
        [Authorize(Roles = RoleNames.Administrator)]
        public async Task<ActionResult<PagedResult<UserResponse>>> Get([FromQuery] UserSearchObject? search = null)
        {
            return await _userService.GetAsync(search ?? new UserSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserResponse>> GetById(int id)
        {
            var uid = CurrentUserId;
            if (uid == null)
                return Unauthorized();
            if (!User.IsInRole(RoleNames.Administrator) && uid != id)
                return Forbid();

            var user = await _userService.GetByIdAsync(id);

            if (user == null)
                return NotFound();

            return user;
        }

        [HttpPost]
        [Authorize(Roles = RoleNames.Administrator)]
        public async Task<ActionResult<UserResponse>> Create(UserUpsertRequest request)
        {
            var createdUser = await _userService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdUser.Id }, createdUser);
        }

        [HttpPost("register")]
        [AllowAnonymous]
        public async Task<ActionResult<UserResponse>> Register([FromBody] UserRegisterRequest request)
        {
            var roleSearch = new RoleSearchObject
            {
                Name = DefaultUserRoleName,
                IsActive = true
            };
            var roles = await _roleService.GetAsync(roleSearch);
            var defaultRole = roles.Items.FirstOrDefault();

            if (defaultRole == null)
            {
                return StatusCode(500, $"Default role '{DefaultUserRoleName}' not found.");
            }

            var createRequest = new UserUpsertRequest
            {
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                Username = request.Username,
                PhoneNumber = request.PhoneNumber,
                GenderId = request.GenderId,
                CityId = request.CityId,
                IsActive = true,
                Password = request.Password,
                Picture = request.Picture,
                RoleIds = new List<int> { defaultRole.Id }
            };

            // The user account and its Patient profile are created in one
            // transaction inside the service (no half-registered accounts).
            var createdUser = await _userService.RegisterPatientAsync(createRequest, dateOfBirth: null);

            return CreatedAtAction(nameof(GetById), new { id = createdUser.Id }, createdUser);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<UserResponse>> Update(int id, UserUpsertRequest request)
        {
            var uid = CurrentUserId;
            if (uid == null)
                return Unauthorized();
            var callerIsAdmin = User.IsInRole(RoleNames.Administrator);
            if (!callerIsAdmin && uid != id)
                return Forbid();

            var updatedUser = await _userService.UpdateAsync(id, request, callerIsAdmin);

            if (updatedUser == null)
                return NotFound();

            return updatedUser;
        }

        /// <summary>
        /// Self-service password change. The caller must be the user in the
        /// route and must supply the current password. Admins change other
        /// users' passwords via PUT /Users/{id} (no old password needed).
        /// </summary>
        [HttpPost("{id}/change-password")]
        public async Task<ActionResult> ChangePassword(int id, [FromBody] ChangePasswordRequest request)
        {
            var uid = CurrentUserId;
            if (uid == null)
                return Unauthorized();
            if (uid != id)
                return Forbid();

            await _userService.ChangeOwnPasswordAsync(id, request.OldPassword, request.NewPassword);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = RoleNames.Administrator)]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _userService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }

        [HttpPost("authenticate")]
        [AllowAnonymous]
        public async Task<ActionResult<AuthResponse>> Authenticate([FromBody] UserLoginRequest request)
        {
            var user = await _userService.AuthenticateAsync(request);
            if (user == null)
                return Unauthorized();
            var token = GenerateJwtToken(user, out var expiresAt);
            return Ok(new AuthResponse
            {
                Token = token,
                ExpiresAt = expiresAt,
                User = user
            });
        }

        /// <summary>
        /// Server-side logout. Records this token's jti in the revocation store
        /// so any subsequent request that presents the same JWT (e.g. a stolen
        /// or shared device) is rejected even before its natural expiry.
        /// </summary>
        [HttpPost("logout")]
        public IActionResult Logout()
        {
            var jti = User.FindFirstValue(JwtRegisteredClaimNames.Jti);
            var expRaw = User.FindFirstValue(JwtRegisteredClaimNames.Exp);
            if (!string.IsNullOrEmpty(jti))
            {
                var exp = long.TryParse(expRaw, out var seconds)
                    ? DateTimeOffset.FromUnixTimeSeconds(seconds)
                    : DateTimeOffset.UtcNow.AddHours(1);
                _revokedTokens.Revoke(jti, exp);
            }
            return NoContent();
        }

        private string GenerateJwtToken(UserResponse user, out DateTime expiresAt)
        {
            var settings = _configuration.GetSection("JwtSettings");
            var secretKey = settings.GetValue<string>("SecretKey") ?? string.Empty;
            var issuer = settings.GetValue<string>("Issuer") ?? string.Empty;
            var audience = settings.GetValue<string>("Audience") ?? string.Empty;
            var expirationMinutes = settings.GetValue<int>("ExpirationMinutes");

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            expiresAt = DateTime.UtcNow.AddMinutes(expirationMinutes);

            // Unique jti per token so /Users/logout can revoke this specific
            // session without invalidating other devices the user is signed in on.
            var jti = Guid.NewGuid().ToString("N");

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(JwtRegisteredClaimNames.Jti, jti),
                new Claim(ClaimTypes.Sid, jti)
            };

            foreach (var role in user.Roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role.Name));
            }

            var token = new JwtSecurityToken(
                issuer: issuer,
                audience: audience,
                claims: claims,
                expires: expiresAt,
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}