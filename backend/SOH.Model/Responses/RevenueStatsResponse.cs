using System.Collections.Generic;

namespace SOH.Model.Responses
{
    public class RevenueStatsResponse
    {
        public List<RevenueCategoryResponse> Categories { get; set; } = new List<RevenueCategoryResponse>();
    }
}
