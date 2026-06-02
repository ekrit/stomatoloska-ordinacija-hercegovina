using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace SOH.WebAPI.Controllers
{
    public class OrderController : BaseCRUDController<OrderResponse, OrderSearchObject, OrderUpsertRequest, OrderUpsertRequest>
    {
        public OrderController(IOrderService service) : base(service)
        {
        }

        // Patients only ever see their own order history; admins see everything.
        // We force-narrow the search filter here instead of trusting the client
        // to pass the right patientId, so a patient cannot list someone else's
        // purchases by guessing IDs.
        public override Task<PagedResult<OrderResponse>> Get([FromQuery] OrderSearchObject? search = null)
        {
            search ??= new OrderSearchObject();
            if (!User.IsInRole(RoleNames.Administrator))
            {
                var uid = int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;
                search.PatientId = uid;
            }
            return base.Get(search);
        }

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<OrderResponse> Create([FromBody] OrderUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<OrderResponse?> Update(int id, [FromBody] OrderUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
