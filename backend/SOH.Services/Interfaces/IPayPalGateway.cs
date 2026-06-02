namespace SOH.Services.Interfaces;

public record PayPalOrderResult(string OrderId, string ApprovalUrl);

public interface IPayPalGateway
{
    Task<PayPalOrderResult> CreateOrderAsync(decimal amountEur, string returnUrl, string cancelUrl, CancellationToken cancellationToken = default);
    Task<string?> CaptureOrderAsync(string orderId, CancellationToken cancellationToken = default);
    Task RefundCaptureAsync(string captureId, CancellationToken cancellationToken = default);
    bool VerifyWebhook(string? transmissionId, string? transmissionTime, string? certUrl, string? authAlgo, string? transmissionSig, string? webhookId, string rawBody);
}
