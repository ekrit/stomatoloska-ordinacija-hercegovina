using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IAppointmentStatusTypeService
        : ICRUDService<StatusTypeResponse, StatusTypeSearchObject, StatusTypeUpsertRequest, StatusTypeUpsertRequest>
    {
    }

    public interface IPaymentStatusTypeService
        : ICRUDService<StatusTypeResponse, StatusTypeSearchObject, StatusTypeUpsertRequest, StatusTypeUpsertRequest>
    {
    }
}
