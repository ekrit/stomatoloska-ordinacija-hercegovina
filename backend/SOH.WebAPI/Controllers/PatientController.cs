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
    public class PatientController : BaseCRUDController<PatientResponse, PatientSearchObject, PatientUpsertRequest, PatientUpsertRequest>
    {
        public PatientController(IPatientService service) : base(service)
        {
        }

        // Patients may only see their own patient record (Patient PK == UserId);
        // staff (doctor/admin) see the full directory.
        public override Task<PagedResult<PatientResponse>> Get([FromQuery] PatientSearchObject? search = null)
        {
            search ??= new PatientSearchObject();
            if (!User.IsInRole(RoleNames.Administrator) && !User.IsInRole(RoleNames.Doctor))
            {
                var uid = int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;
                search.UserId = uid;
            }
            return base.Get(search);
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
