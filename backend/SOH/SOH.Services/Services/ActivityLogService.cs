using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class ActivityLogService : BaseCRUDService<ActivityLogResponse, ActivityLogSearchObject, ActivityLog, ActivityLogUpsertRequest, ActivityLogUpsertRequest>, IActivityLogService
    {
        public ActivityLogService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<ActivityLog> ApplyFilter(IQueryable<ActivityLog> query, ActivityLogSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Action))
            {
                query = query.Where(x => x.Action.Contains(search.Action));
            }

            if (!string.IsNullOrEmpty(search.EntityName))
            {
                query = query.Where(x => x.EntityName.Contains(search.EntityName));
            }

            if (!string.IsNullOrEmpty(search.EntityId))
            {
                query = query.Where(x => x.EntityId != null && x.EntityId.Contains(search.EntityId));
            }

            if (search.CreatedFrom.HasValue)
            {
                query = query.Where(x => x.CreatedAt >= search.CreatedFrom.Value);
            }

            if (search.CreatedTo.HasValue)
            {
                query = query.Where(x => x.CreatedAt <= search.CreatedTo.Value);
            }

            return query;
        }
    }
}
