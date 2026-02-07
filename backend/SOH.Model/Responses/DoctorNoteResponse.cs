using System;

namespace SOH.Model.Responses
{
    public class DoctorNoteResponse
    {
        public int Id { get; set; }
        public int AppointmentId { get; set; }
        public string Note { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }
}
