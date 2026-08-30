using SOH.Model.Exceptions;
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

        // Patients may only see their own patient record (Patient PK == UserId);
        // staff (doctor/admin) see the full directory.
        public override Task<PagedResult<PatientResponse>> Get([FromQuery] PatientSearchObject? search = null)
        {
            search ??= new PatientSearchObject();
            if (!CallerIsAdmin && !CallerIsDoctor)
            {
                search.UserId = CallerUserId;
            }
            return base.Get(search);
        }

        // Staff read the whole directory (a doctor needs the chart of whoever
        // walks in), but a patient may only read their own record — the Patient
        // primary key is the UserId, so the route id is the owner's id.
        public override async Task<PatientResponse?> GetById(int id)
        {
            if (!CallerIsAdmin && !CallerIsDoctor && id != CallerUserId)
            {
                throw new ForbiddenException("Nemate pravo pristupa ovom zapisu.");
            }
            return await base.GetById(id);
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
