using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class ReportController : BaseCRUDController<ReportResponse, ReportSearchObject, ReportUpsertRequest, ReportUpsertRequest>
    {
        public ReportController(IReportService service) : base(service)
        {
        }
    }
}
