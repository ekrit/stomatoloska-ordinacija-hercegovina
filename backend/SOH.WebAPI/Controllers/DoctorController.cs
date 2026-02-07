using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class DoctorController : BaseCRUDController<DoctorResponse, DoctorSearchObject, DoctorUpsertRequest, DoctorUpsertRequest>
    {
        public DoctorController(IDoctorService service) : base(service)
        {
        }
    }
}
