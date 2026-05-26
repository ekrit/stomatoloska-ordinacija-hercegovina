using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class ReminderController : BaseCRUDController<ReminderResponse, ReminderSearchObject, ReminderUpsertRequest, ReminderUpsertRequest>
    {
        public ReminderController(IReminderService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override Task<ReminderResponse> Create([FromBody] ReminderUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override Task<ReminderResponse?> Update(int id, [FromBody] ReminderUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
