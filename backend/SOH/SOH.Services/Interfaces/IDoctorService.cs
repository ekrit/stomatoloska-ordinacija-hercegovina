using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IDoctorService : ICRUDService<DoctorResponse, DoctorSearchObject, DoctorUpsertRequest, DoctorUpsertRequest>
    {
    }
}
