using System.Collections.Generic;

namespace SOH.Model.Responses;

public class RecommendedProductResponse
{
    public ProductResponse Product { get; set; } = null!;

    /// <summary>
    /// Human-readable reasons (content-based, popularity, personal history).
    /// </summary>
    public List<string> Reasons { get; set; } = new();

    public double Score { get; set; }
}
