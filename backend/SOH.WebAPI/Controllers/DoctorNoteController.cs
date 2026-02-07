using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class DoctorNoteController : BaseCRUDController<DoctorNoteResponse, DoctorNoteSearchObject, DoctorNoteUpsertRequest, DoctorNoteUpsertRequest>
    {
        public DoctorNoteController(IDoctorNoteService service) : base(service)
        {
        }
    }
}
