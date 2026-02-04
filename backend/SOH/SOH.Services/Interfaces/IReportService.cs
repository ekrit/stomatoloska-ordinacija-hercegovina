using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IReportService : ICRUDService<ReportResponse, ReportSearchObject, ReportUpsertRequest, ReportUpsertRequest>
    {
    }
}
