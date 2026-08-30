namespace SOH.Services.Interfaces;

public record PayPalOrderResult(string OrderId, string ApprovalUrl);

public interface IPayPalGateway
{
    /// <summary>Creates an order for an amount already expressed in the provider currency (see <c>MoneyPolicy</c>).</summary>
    Task<PayPalOrderResult> CreateOrderAsync(decimal amountInProviderCurrency, string returnUrl, string cancelUrl, CancellationToken cancellationToken = default);
    /// <summary>
    /// Current approval link for an existing order, or null when the order can
    /// no longer be approved (expired, already captured, or unknown). Used to
    /// resume an abandoned checkout instead of creating a second order.
    /// </summary>
    Task<string?> GetApprovalUrlAsync(string orderId, CancellationToken cancellationToken = default);

    Task<string?> CaptureOrderAsync(string orderId, CancellationToken cancellationToken = default);
    Task RefundCaptureAsync(string captureId, CancellationToken cancellationToken = default);
    Task<bool> VerifyWebhookAsync(string? transmissionId, string? transmissionTime, string? certUrl, string? authAlgo, string? transmissionSig, string rawBody, CancellationToken cancellationToken = default);
}
