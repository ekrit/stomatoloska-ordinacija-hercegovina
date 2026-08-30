using System.Security.Claims;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Services
{
    public class HttpContextCurrentUserAccessor : ICurrentUserAccessor
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public HttpContextCurrentUserAccessor(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        private ClaimsPrincipal? Principal => _httpContextAccessor.HttpContext?.User;

        public int? UserId =>
            int.TryParse(
                Principal?.FindFirstValue(ClaimTypes.NameIdentifier),
                out var id)
                ? id
                : null;

        public string? Username => Principal?.FindFirstValue(ClaimTypes.Name);

        public bool IsAdministrator => Principal?.IsInRole(RoleNames.Administrator) == true;

        public bool IsDoctor => Principal?.IsInRole(RoleNames.Doctor) == true;

        public bool IsPatient =>
            Principal?.Identity?.IsAuthenticated == true && !IsAdministrator && !IsDoctor;
    }
}
