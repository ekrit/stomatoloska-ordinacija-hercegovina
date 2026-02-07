using System;
using SOH.Model.Enums;

namespace SOH.Model.Responses
{
    public class AppointmentResponse
    {
        public int Id { get; set; }
        public int PatientId { get; set; }
        public int DoctorId { get; set; }
        public int ServiceId { get; set; }
        public int RoomId { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public AppointmentStatus Status { get; set; }
        public string? DoctorNote { get; set; }
    }
}
