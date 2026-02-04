using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class MedicalRecordController : BaseCRUDController<MedicalRecordResponse, MedicalRecordSearchObject, MedicalRecordUpsertRequest, MedicalRecordUpsertRequest>
    {
        public MedicalRecordController(IMedicalRecordService service) : base(service)
        {
        }
    }
}
