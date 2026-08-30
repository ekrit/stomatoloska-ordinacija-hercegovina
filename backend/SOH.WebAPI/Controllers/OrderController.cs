using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class OrderController : BaseCRUDController<OrderResponse, OrderSearchObject, OrderUpsertRequest, OrderUpsertRequest>
    {
        private readonly IOrderService _orders;

        public OrderController(IOrderService service) : base(service)
        {
            _orders = service;
        }

        // Patients only ever see their own order history; admins see everything.
        // We force-narrow the search filter here instead of trusting the client
        // to pass the right patientId, so a patient cannot list someone else's
        // purchases by guessing IDs.
        public override Task<PagedResult<OrderResponse>> Get([FromQuery] OrderSearchObject? search = null)
        {
            search ??= new OrderSearchObject();
            if (!CallerIsAdmin)
            {
                search.PatientId = CallerUserId;
            }
            return base.Get(search);
        }

        // A single order read by id must belong to the caller too; the scoped
        // list alone still let a guessed id reveal another patient's purchase.
        public override async Task<OrderResponse?> GetById(int id)
        {
            await EnsureCallerMayAccessAsync(_orders, id);
            return await base.GetById(id);
        }

        // The owning patient is taken from the JWT in OrderService.BeforeInsert,
        // so a client-supplied PatientId cannot order in someone else's name.
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<OrderResponse> Create([FromBody] OrderUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override async Task<OrderResponse?> Update(int id, [FromBody] OrderUpsertRequest request)
        {
            await EnsureCallerMayAccessAsync(_orders, id);
            return await base.Update(id, request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
