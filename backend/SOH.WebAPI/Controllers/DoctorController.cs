using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    public class DoctorController : BaseCRUDController<DoctorResponse, DoctorSearchObject, DoctorUpsertRequest, DoctorUpsertRequest>
    {
        public DoctorController(IDoctorService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<DoctorResponse> Create([FromBody] DoctorUpsertRequest request)
        {
            return await base.Create(request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<DoctorResponse?> Update(int id, [FromBody] DoctorUpsertRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<bool> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
}
