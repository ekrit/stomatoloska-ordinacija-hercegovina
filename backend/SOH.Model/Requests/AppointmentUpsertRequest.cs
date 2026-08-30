using System;
using System.ComponentModel.DataAnnotations;
using SOH.Model.Enums;

namespace SOH.Model.Requests
{
    public class AppointmentUpsertRequest
    {
        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
        public int PatientId { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
        public int DoctorId { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
        public int ServiceId { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
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
