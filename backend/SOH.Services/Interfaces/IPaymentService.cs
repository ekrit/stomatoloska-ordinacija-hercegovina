using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IPaymentService : ICRUDService<PaymentResponse, PaymentSearchObject, PaymentUpsertRequest, PaymentUpsertRequest>
    {
        /// <summary>Creates a Pending payment for the appointment and a PayPal order. Amount comes from the service catalog.</summary>
        Task<PaymentOrderCreateResponse> CreateOrderAsync(int appointmentId, int callerUserId, bool isAdmin, CancellationToken cancellationToken = default);

        /// <summary>Captures the PayPal order tied to the payment. Idempotent: a Paid payment returns success without re-capturing.</summary>
        Task<PaymentCaptureResponse> CaptureOrderAsync(int paymentId, int callerUserId, bool isAdmin, CancellationToken cancellationToken = default);

        /// <summary>Refunds a paid payment. Only allowed while the appointment is not Completed. Cancels the appointment on success.</summary>
        Task RefundAsync(int paymentId, int callerUserId, bool isAdmin, CancellationToken cancellationToken = default);

        /// <summary>Applies an async PayPal webhook event (capture completed / refunded) to the matching payment.</summary>
        Task HandleWebhookAsync(string eventType, string? payPalOrderId, string? captureId, CancellationToken cancellationToken = default);
    }
}
