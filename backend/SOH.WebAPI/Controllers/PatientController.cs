using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class PatientController : BaseCRUDController<PatientResponse, PatientSearchObject, PatientUpsertRequest, PatientUpsertRequest>
    {
        public PatientController(IPatientService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<PatientResponse> Create([FromBody] PatientUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<PatientResponse?> Update(int id, [FromBody] PatientUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
