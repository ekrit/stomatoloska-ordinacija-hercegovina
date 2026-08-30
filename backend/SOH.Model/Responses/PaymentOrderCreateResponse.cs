namespace SOH.Model.Responses;

public class PaymentOrderCreateResponse
{
    public int PaymentId { get; set; }
    public string OrderId { get; set; } = string.Empty;
    public string ApprovalUrl { get; set; } = string.Empty;

    /// <summary>Amount owed, in the clinic's business currency.</summary>
    public decimal Amount { get; set; }

    /// <summary>Business currency of <see cref="Amount"/> (BAM).</summary>
    public string Currency { get; set; } = string.Empty;

    /// <summary>What PayPal will actually charge, after conversion.</summary>
    public decimal ChargedAmount { get; set; }

    /// <summary>Currency of <see cref="ChargedAmount"/> (EUR).</summary>
    public string ChargedCurrency { get; set; } = string.Empty;
}
