using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IPatientService : ICRUDService<PatientResponse, PatientSearchObject, PatientUpsertRequest, PatientUpsertRequest>
    {
    }
}
