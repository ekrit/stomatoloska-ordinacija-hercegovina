using System;

namespace SOH.Model.Responses
{
    public class ReminderResponse
    {
        public int Id { get; set; }
        public int PatientId { get; set; }
        public string Type { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public DateTime ScheduledFor { get; set; }
    }
}
