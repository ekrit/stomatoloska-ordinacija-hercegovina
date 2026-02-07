using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IActivityLogService : ICRUDService<ActivityLogResponse, ActivityLogSearchObject, ActivityLogUpsertRequest, ActivityLogUpsertRequest>
    {
    }
}
