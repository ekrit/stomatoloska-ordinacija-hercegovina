namespace SOH.Model.Responses;

public class PaymentOrderCreateResponse
{
    public int PaymentId { get; set; }
    public string OrderId { get; set; } = string.Empty;
    public string ApprovalUrl { get; set; } = string.Empty;
    public decimal Amount { get; set; }
}
