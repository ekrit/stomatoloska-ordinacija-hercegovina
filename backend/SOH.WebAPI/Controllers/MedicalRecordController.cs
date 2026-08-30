using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class MedicalRecordController : BaseCRUDController<MedicalRecordResponse, MedicalRecordSearchObject, MedicalRecordUpsertRequest, MedicalRecordUpsertRequest>
    {
        private readonly IMedicalRecordService _records;

        public MedicalRecordController(IMedicalRecordService service) : base(service)
        {
            _records = service;
        }

        // Patients may only read records for their own appointments; the
        // patient id is pinned from the JWT so the query string cannot widen
        // the result. Doctors and admins see everything.
        public override Task<PagedResult<MedicalRecordResponse>> Get([FromQuery] MedicalRecordSearchObject? search = null)
        {
            search ??= new MedicalRecordSearchObject();
            if (!CallerIsAdmin && !CallerIsDoctor)
            {
                search.PatientId = CallerUserId;
            }
            return base.Get(search);
        }

        // A finding read by id is bound to the appointment it belongs to: the
        // patient who was treated, or the doctor who treated them. Restricting
        // this to staff as a whole still let one doctor read a colleague's
        // findings for any id they cared to try.
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override async Task<MedicalRecordResponse?> GetById(int id)
        {
            await EnsureCallerMayAccessAsync(_records, id);
            return await base.GetById(id);
        }

        // Doctor scope for create/update is enforced in MedicalRecordService,
        // which binds the finding to an appointment the doctor actually owns.
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
