using System;

namespace SOH.Model.Responses
{
    public class ReportResponse
    {
        public int Id { get; set; }
        public string Type { get; set; } = string.Empty;
        public DateTime GeneratedAt { get; set; }
        public string Parameters { get; set; } = string.Empty;
    }
}
