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

        /// <summary>What the patient reports when booking.</summary>
        [MaxLength(2000)]
        public string? PatientComplaint { get; set; }

        /// <summary>The doctor's own note; not a substitute for a reason.</summary>
        [MaxLength(2000)]
        public string? DoctorNote { get; set; }

        /// <summary>Required when moving the appointment to Declined.</summary>
        [MaxLength(2000)]
        public string? DeclineReason { get; set; }
    }
}
