using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class ReportService : BaseCRUDService<ReportResponse, ReportSearchObject, Report, ReportUpsertRequest, ReportUpsertRequest>, IReportService
    {
        public ReportService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Report> ApplyFilter(IQueryable<Report> query, ReportSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Type))
            {
                query = query.Where(x => x.Type.Contains(search.Type));
            }

            if (search.GeneratedFrom.HasValue)
            {
                query = query.Where(x => x.GeneratedAt >= search.GeneratedFrom.Value);
            }

            if (search.GeneratedTo.HasValue)
            {
                query = query.Where(x => x.GeneratedAt <= search.GeneratedTo.Value);
            }

            return query;
        }
    }
}
