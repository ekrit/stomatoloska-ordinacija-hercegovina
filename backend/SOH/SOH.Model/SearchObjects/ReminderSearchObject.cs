using System;

namespace SOH.Model.SearchObjects
{
    public class ReminderSearchObject : BaseSearchObject
    {
        public int? PatientId { get; set; }
        public string? Type { get; set; }
        public DateTime? ScheduledFrom { get; set; }
        public DateTime? ScheduledTo { get; set; }
    }
}
