using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class ReminderController : BaseCRUDController<ReminderResponse, ReminderSearchObject, ReminderUpsertRequest, ReminderUpsertRequest>
    {
        public ReminderController(IReminderService service) : base(service)
        {
        }
    }
}
