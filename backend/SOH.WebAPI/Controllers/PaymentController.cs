using Microsoft.AspNetCore.Authorization;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    [Authorize(Roles = RoleNames.Administrator)]
    public class PaymentController : BaseCRUDController<PaymentResponse, PaymentSearchObject, PaymentUpsertRequest, PaymentUpsertRequest>
    {
        public PaymentController(IPaymentService service) : base(service)
        {
        }
    }
}
