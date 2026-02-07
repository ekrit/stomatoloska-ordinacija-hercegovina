using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using Microsoft.AspNetCore.Mvc;
using SOH.Services.Interfaces;
using SOH.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Collections.Generic;

namespace SOH.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class UsersController : ControllerBase
    {
        private const string DefaultUserRoleName = "User";
        private readonly IUserService _userService;
        private readonly IRoleService _roleService;
        private readonly IConfiguration _configuration;

        public UsersController(IUserService userService, IRoleService roleService, IConfiguration configuration)
        {
            _userService = userService;
            _roleService = roleService;
            _configuration = configuration;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<UserResponse>>> Get([FromQuery] UserSearchObject? search = null)
        {
            return await _userService.GetAsync(search ?? new UserSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserResponse>> GetById(int id)
        {
            var user = await _userService.GetByIdAsync(id);

            if (user == null)
                return NotFound();

            return user;
        }

        [HttpPost]
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
                IsActive = true,
                RetrieveAll = true
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

            var createdUser = await _userService.CreateAsync(createRequest);
            return CreatedAtAction(nameof(GetById), new { id = createdUser.Id }, createdUser);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<UserResponse>> Update(int id, UserUpsertRequest request)
        {
            var updatedUser = await _userService.UpdateAsync(id, request);

            if (updatedUser == null)
                return NotFound();

            return updatedUser;
        }

        [HttpDelete("{id}")]
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

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Email, user.Email)
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