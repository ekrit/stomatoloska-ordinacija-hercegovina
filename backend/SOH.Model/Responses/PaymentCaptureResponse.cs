namespace SOH.Model.Responses;

public class PaymentCaptureResponse
{
    public bool IsPaid { get; set; }
    public int PaymentId { get; set; }
    public string? TransactionRef { get; set; }
}
