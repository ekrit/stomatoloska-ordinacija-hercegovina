using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace SOH.WebAPI.Controllers
{
    public class HygieneTrackerController : BaseCRUDController<HygieneTrackerResponse, HygieneTrackerSearchObject, HygieneTrackerUpsertRequest, HygieneTrackerUpsertRequest>
    {
        public HygieneTrackerController(IHygieneTrackerService service) : base(service)
        {
        }

        // Hygiene history is private to each patient; admins can audit it all.
        public override Task<PagedResult<HygieneTrackerResponse>> Get([FromQuery] HygieneTrackerSearchObject? search = null)
        {
            search ??= new HygieneTrackerSearchObject();
            if (!User.IsInRole(RoleNames.Administrator))
            {
                var uid = int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;
                search.PatientId = uid;
            }
            return base.Get(search);
        }

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<HygieneTrackerResponse> Create([FromBody] HygieneTrackerUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<HygieneTrackerResponse?> Update(int id, [FromBody] HygieneTrackerUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
