using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class OrderController : BaseCRUDController<OrderResponse, OrderSearchObject, OrderUpsertRequest, OrderUpsertRequest>
    {
        public OrderController(IOrderService service) : base(service)
        {
        }
    }
}
