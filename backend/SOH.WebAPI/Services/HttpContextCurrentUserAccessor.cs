using System.Security.Claims;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Services
{
    public class HttpContextCurrentUserAccessor : ICurrentUserAccessor
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public HttpContextCurrentUserAccessor(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public int? UserId =>
            int.TryParse(
                _httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier),
                out var id)
                ? id
                : null;

        public string? Username =>
            _httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.Name);
    }
}
