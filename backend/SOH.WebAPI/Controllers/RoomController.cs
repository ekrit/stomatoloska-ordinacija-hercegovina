using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class RoomController : BaseCRUDController<RoomResponse, RoomSearchObject, RoomUpsertRequest, RoomUpsertRequest>
    {
        public RoomController(IRoomService service) : base(service)
        {
        }
    }
}
