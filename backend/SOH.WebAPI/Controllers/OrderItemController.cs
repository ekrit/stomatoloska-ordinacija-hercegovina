using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class OrderItemController : BaseCRUDController<OrderItemResponse, OrderItemSearchObject, OrderItemUpsertRequest, OrderItemUpsertRequest>
    {
        public OrderItemController(IOrderItemService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<OrderItemResponse> Create([FromBody] OrderItemUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<OrderItemResponse?> Update(int id, [FromBody] OrderItemUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
