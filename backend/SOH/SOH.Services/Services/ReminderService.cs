using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class ReminderService : BaseCRUDService<ReminderResponse, ReminderSearchObject, Reminder, ReminderUpsertRequest, ReminderUpsertRequest>, IReminderService
    {
        public ReminderService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Reminder> ApplyFilter(IQueryable<Reminder> query, ReminderSearchObject search)
        {
            if (search.PatientId.HasValue)
            {
                query = query.Where(x => x.PatientId == search.PatientId.Value);
            }

            if (!string.IsNullOrEmpty(search.Type))
            {
                query = query.Where(x => x.Type.Contains(search.Type));
            }

            if (search.ScheduledFrom.HasValue)
            {
                query = query.Where(x => x.ScheduledFor >= search.ScheduledFrom.Value);
            }

            if (search.ScheduledTo.HasValue)
            {
                query = query.Where(x => x.ScheduledFor <= search.ScheduledTo.Value);
            }

            return query;
        }
    }
}
