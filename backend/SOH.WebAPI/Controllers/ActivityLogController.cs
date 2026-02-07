using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class ActivityLogController : BaseCRUDController<ActivityLogResponse, ActivityLogSearchObject, ActivityLogUpsertRequest, ActivityLogUpsertRequest>
    {
        public ActivityLogController(IActivityLogService service) : base(service)
        {
        }
    }
}
