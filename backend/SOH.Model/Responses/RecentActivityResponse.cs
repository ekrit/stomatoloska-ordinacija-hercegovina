using System.Collections.Generic;

namespace SOH.Model.Responses
{
    public class RecentActivityResponse
    {
        public List<ActivityLogResponse> Items { get; set; } = new();

        /// <summary>Total number of logged actions, not just the returned slice.</summary>
        public int TotalCount { get; set; }
    }
}
