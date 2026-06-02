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
    public class MedicalRecordController : BaseCRUDController<MedicalRecordResponse, MedicalRecordSearchObject, MedicalRecordUpsertRequest, MedicalRecordUpsertRequest>
    {
        public MedicalRecordController(IMedicalRecordService service) : base(service)
        {
        }

        // Patients may only read records for their own appointments; the
        // patient id is pinned from the JWT so the query string cannot widen
        // the result. Doctors and admins see everything.
        public override Task<PagedResult<MedicalRecordResponse>> Get([FromQuery] MedicalRecordSearchObject? search = null)
        {
            search ??= new MedicalRecordSearchObject();
            if (!User.IsInRole(RoleNames.Administrator) && !User.IsInRole(RoleNames.Doctor))
            {
                var uid = int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;
                search.PatientId = uid;
            }
            return base.Get(search);
        }

        // A single record by id reveals a diagnosis with no ownership context,
        // so it is staff-only. Patients read findings via the scoped list.
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override Task<MedicalRecordResponse?> GetById(int id) => base.GetById(id);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override Task<MedicalRecordResponse> Create([FromBody] MedicalRecordUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override Task<MedicalRecordResponse?> Update(int id, [FromBody] MedicalRecordUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
