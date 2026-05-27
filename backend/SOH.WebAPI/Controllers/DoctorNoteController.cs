using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class DoctorNoteController : BaseCRUDController<DoctorNoteResponse, DoctorNoteSearchObject, DoctorNoteUpsertRequest, DoctorNoteUpsertRequest>
    {
        public DoctorNoteController(IDoctorNoteService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override Task<DoctorNoteResponse> Create([FromBody] DoctorNoteUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override Task<DoctorNoteResponse?> Update(int id, [FromBody] DoctorNoteUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
