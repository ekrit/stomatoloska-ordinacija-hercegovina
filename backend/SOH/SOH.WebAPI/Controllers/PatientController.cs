using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class PatientController : BaseCRUDController<PatientResponse, PatientSearchObject, PatientUpsertRequest, PatientUpsertRequest>
    {
        public PatientController(IPatientService service) : base(service)
        {
        }
    }
}
