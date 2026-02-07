using System;

namespace SOH.Model.Responses
{
    public class ActivityLogResponse
    {
        public int Id { get; set; }
        public string Action { get; set; } = string.Empty;
        public string EntityName { get; set; } = string.Empty;
        public string? EntityId { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
