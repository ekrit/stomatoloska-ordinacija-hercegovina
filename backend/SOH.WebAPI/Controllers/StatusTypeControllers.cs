using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    /// <summary>
    /// Reference data (codebook) for appointment statuses. Reading is open to
    /// any signed-in user so the clients can label statuses; maintaining the
    /// codebook is administrator-only.
    /// </summary>
    public class AppointmentStatusTypeController
        : BaseCRUDController<StatusTypeResponse, StatusTypeSearchObject, StatusTypeUpsertRequest, StatusTypeUpsertRequest>
    {
        public AppointmentStatusTypeController(IAppointmentStatusTypeService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<StatusTypeResponse> Create([FromBody] StatusTypeUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<StatusTypeResponse?> Update(int id, [FromBody] StatusTypeUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }

    /// <summary>Reference data (codebook) for payment statuses.</summary>
    public class PaymentStatusTypeController
        : BaseCRUDController<StatusTypeResponse, StatusTypeSearchObject, StatusTypeUpsertRequest, StatusTypeUpsertRequest>
    {
        public PaymentStatusTypeController(IPaymentStatusTypeService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<StatusTypeResponse> Create([FromBody] StatusTypeUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<StatusTypeResponse?> Update(int id, [FromBody] StatusTypeUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
