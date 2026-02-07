using System;
using System.ComponentModel.DataAnnotations;
using SOH.Model.Enums;

namespace SOH.Model.Requests
{
    public class AppointmentUpsertRequest
    {
        [Required]
        public int PatientId { get; set; }

        [Required]
        public int DoctorId { get; set; }

        [Required]
        public int ServiceId { get; set; }

        [Required]
        public int RoomId { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        [Required]
        public DateTime EndTime { get; set; }

        public AppointmentStatus Status { get; set; }

        [MaxLength(2000)]
        public string? DoctorNote { get; set; }
    }
}
