using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class HygieneTrackerController : BaseCRUDController<HygieneTrackerResponse, HygieneTrackerSearchObject, HygieneTrackerUpsertRequest, HygieneTrackerUpsertRequest>
    {
        public HygieneTrackerController(IHygieneTrackerService service) : base(service)
        {
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
