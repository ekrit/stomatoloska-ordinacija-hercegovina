using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SOH.Services.Database
{
    public class Appointment
    {
        [Key]
        public int Id { get; set; }

        public int PatientId { get; set; }
        public int DoctorId { get; set; }
        public int ServiceId { get; set; }
        public int RoomId { get; set; }

        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }

        public AppointmentStatus Status { get; set; }

        /// <summary>
        /// What the patient wrote when booking. Kept apart from
        /// <see cref="DoctorNote"/>: one field previously carried the
        /// complaint, the doctor's note and the rejection reason at once, so a
        /// "reason is present" check passed on text the patient had typed.
        /// </summary>
        [MaxLength(2000)]
        public string? PatientComplaint { get; set; }

        /// <summary>The doctor's own note about the visit.</summary>
        [MaxLength(2000)]
        public string? DoctorNote { get; set; }

        /// <summary>Why the doctor rejected the request. Required to decline.</summary>
        [MaxLength(2000)]
        public string? DeclineReason { get; set; }

        /// <summary>Why the appointment was cancelled. Required to cancel.</summary>
        [MaxLength(2000)]
        public string? CancelReason { get; set; }

        [ForeignKey(nameof(PatientId))]
        public Patient Patient { get; set; } = null!;

        [ForeignKey(nameof(DoctorId))]
        public Doctor Doctor { get; set; } = null!;

        [ForeignKey(nameof(ServiceId))]
        public Service Service { get; set; } = null!;

        [ForeignKey(nameof(RoomId))]
        public Room Room { get; set; } = null!;

        public MedicalRecord? MedicalRecord { get; set; }
        public Payment? Payment { get; set; }
        public Review? Review { get; set; }

        public ICollection<AppointmentStatusHistory> StatusHistory { get; set; } = new List<AppointmentStatusHistory>();
    }
}
