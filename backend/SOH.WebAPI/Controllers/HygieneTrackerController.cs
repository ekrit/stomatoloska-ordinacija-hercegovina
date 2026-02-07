using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class HygieneTrackerController : BaseCRUDController<HygieneTrackerResponse, HygieneTrackerSearchObject, HygieneTrackerUpsertRequest, HygieneTrackerUpsertRequest>
    {
        public HygieneTrackerController(IHygieneTrackerService service) : base(service)
        {
        }
    }
}
