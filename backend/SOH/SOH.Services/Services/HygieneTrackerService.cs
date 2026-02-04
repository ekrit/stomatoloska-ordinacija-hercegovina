using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class HygieneTrackerService : BaseCRUDService<HygieneTrackerResponse, HygieneTrackerSearchObject, HygieneTracker, HygieneTrackerUpsertRequest, HygieneTrackerUpsertRequest>, IHygieneTrackerService
    {
        public HygieneTrackerService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<HygieneTracker> ApplyFilter(IQueryable<HygieneTracker> query, HygieneTrackerSearchObject search)
        {
            if (search.PatientId.HasValue)
            {
                query = query.Where(x => x.PatientId == search.PatientId.Value);
            }

            if (search.DateFrom.HasValue)
            {
                query = query.Where(x => x.Date >= search.DateFrom.Value);
            }

            if (search.DateTo.HasValue)
            {
                query = query.Where(x => x.Date <= search.DateTo.Value);
            }

            return query;
        }
    }
}
