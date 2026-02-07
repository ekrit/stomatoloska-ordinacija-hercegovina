using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class OrderItemController : BaseCRUDController<OrderItemResponse, OrderItemSearchObject, OrderItemUpsertRequest, OrderItemUpsertRequest>
    {
        public OrderItemController(IOrderItemService service) : base(service)
        {
        }
    }
}
