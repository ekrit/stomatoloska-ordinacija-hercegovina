using SOH.Model.Exceptions;
using SOH.Model.SearchObjects;
using SOH.Model.Responses;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using System.Security.Claims;

namespace SOH.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class BaseController<T, TSearch> : ControllerBase where T : class where TSearch : BaseSearchObject, new()
    {
        protected readonly IService<T, TSearch> _service;

        public BaseController(IService<T, TSearch> service) {
            _service = service;
        }

        /// <summary>The caller's <c>User.Id</c> as carried by the JWT, or 0.</summary>
        protected int CallerUserId =>
            int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;

        protected bool CallerIsAdmin => User.IsInRole(RoleNames.Administrator);

        protected bool CallerIsDoctor => User.IsInRole(RoleNames.Doctor);

        /// <summary>
        /// Per-record authorization for single-record reads. Narrowing the list
        /// endpoint is not enough on its own: without this an authenticated user
        /// could open someone else's appointment, order or payment simply by
        /// putting a known or guessed id in the URL. Administrators keep the
        /// broad access their screens need; a doctor is bound to records where
        /// they are the assigned doctor, everyone else to their own patient
        /// records.
        /// </summary>
        protected async Task EnsureCallerMayAccessAsync(
            IRecordOwnership ownership,
            int id,
            CancellationToken cancellationToken = default)
        {
            if (CallerIsAdmin)
            {
                return;
            }

            var owner = await ownership.GetOwnerAsync(id, cancellationToken)
                ?? throw new NotFoundException("Traženi zapis nije pronađen.");

            var callerId = CallerUserId;
            var allowed = CallerIsDoctor
                ? owner.DoctorId == callerId
                : owner.PatientId == callerId;

            if (!allowed)
            {
                throw new ForbiddenException("Nemate pravo pristupa ovom zapisu.");
            }
        }

        [HttpGet("")]
        public virtual async Task<PagedResult<T>> Get([FromQuery]TSearch? search = null)
        {
            return await _service.GetAsync(search ?? new TSearch());
        }

        [HttpGet("{id}")]
        public virtual async Task<T?> GetById(int id)
        {
            return await _service.GetByIdAsync(id);
        }
    }
}
