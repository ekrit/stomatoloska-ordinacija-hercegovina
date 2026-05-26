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
        public MedicalRecordController(IMedicalRecordService service) : base(service)
        {
        }

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
