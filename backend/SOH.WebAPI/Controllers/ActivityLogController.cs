using Microsoft.AspNetCore.Authorization;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    [Authorize(Roles = RoleNames.Administrator)]
    public class ActivityLogController : BaseCRUDController<ActivityLogResponse, ActivityLogSearchObject, ActivityLogUpsertRequest, ActivityLogUpsertRequest>
    {
        public ActivityLogController(IActivityLogService service) : base(service)
        {
        }
    }
}
