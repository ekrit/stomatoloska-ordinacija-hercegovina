using System;

namespace SOH.Model.Notifications
{
    public class AppointmentReminderMessage
    {
        public int AppointmentId { get; set; }
        public int PatientId { get; set; }
        public int DoctorId { get; set; }
        public int ServiceId { get; set; }
        public DateTime StartTimeUtc { get; set; }
        public string? ClientComplaint { get; set; }
        public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    }
}
