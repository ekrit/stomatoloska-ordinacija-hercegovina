using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    [Authorize]
    public class PaymentController : BaseCRUDController<PaymentResponse, PaymentSearchObject, PaymentUpsertRequest, PaymentUpsertRequest>
    {
        private readonly IPaymentService _payments;
        private readonly IPayPalGateway _payPal;

        public PaymentController(IPaymentService service, IPayPalGateway payPal) : base(service)
        {
            _payments = service;
            _payPal = payPal;
        }

        private int CallerUserId =>
            int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;

        private bool CallerIsAdmin => User.IsInRole(RoleNames.Administrator);

        // Raw CRUD list/mutations stay admin-only; patients use the flow endpoints below.
        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<PagedResult<PaymentResponse>> Get([FromQuery] PaymentSearchObject? search = null)
            => base.Get(search);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<PaymentResponse> Create([FromBody] PaymentUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<PaymentResponse?> Update(int id, [FromBody] PaymentUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);

        [HttpPost("orders")]
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public async Task<ActionResult<PaymentOrderCreateResponse>> CreateOrder([FromBody] PaymentOrderCreateRequest request)
        {
            var result = await _payments.CreateOrderAsync(request.AppointmentId, CallerUserId, CallerIsAdmin);
            return Ok(result);
        }

        [HttpPost("orders/{paymentId}/capture")]
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public async Task<ActionResult<PaymentCaptureResponse>> Capture(int paymentId)
        {
            var result = await _payments.CaptureOrderAsync(paymentId, CallerUserId, CallerIsAdmin);
            return Ok(result);
        }

        [HttpPost("{paymentId}/refund")]
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public async Task<IActionResult> Refund(int paymentId)
        {
            await _payments.RefundAsync(paymentId, CallerUserId, CallerIsAdmin);
            return NoContent();
        }

        // PayPal calls this server-to-server; no JWT. Signature/webhook id is verified.
        [HttpPost("webhook")]
        [AllowAnonymous]
        public async Task<IActionResult> Webhook()
        {
            string rawBody;
            using (var reader = new StreamReader(Request.Body))
            {
                rawBody = await reader.ReadToEndAsync();
            }

            var ok = _payPal.VerifyWebhook(
                Request.Headers["PAYPAL-TRANSMISSION-ID"],
                Request.Headers["PAYPAL-TRANSMISSION-TIME"],
                Request.Headers["PAYPAL-CERT-URL"],
                Request.Headers["PAYPAL-AUTH-ALGO"],
                Request.Headers["PAYPAL-TRANSMISSION-SIG"],
                Request.Headers["PAYPAL-WEBHOOK-ID"],
                rawBody);

            if (!ok)
            {
                return Unauthorized();
            }

            if (string.IsNullOrWhiteSpace(rawBody))
            {
                return Ok();
            }

            using var doc = JsonDocument.Parse(rawBody);
            var root = doc.RootElement;
            var eventType = root.TryGetProperty("event_type", out var et) ? et.GetString() ?? string.Empty : string.Empty;

            string? captureId = null;
            string? orderId = null;
            if (root.TryGetProperty("resource", out var resource))
            {
                if (resource.TryGetProperty("id", out var rid))
                {
                    captureId = rid.GetString();
                }
                if (resource.TryGetProperty("supplementary_data", out var supp) &&
                    supp.TryGetProperty("related_ids", out var related) &&
                    related.TryGetProperty("order_id", out var oid))
                {
                    orderId = oid.GetString();
                }
            }

            await _payments.HandleWebhookAsync(eventType, orderId, captureId);
            return Ok();
        }
    }
}
