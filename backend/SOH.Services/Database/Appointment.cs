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

        [MaxLength(2000)]
        public string? DoctorNote { get; set; }

        [ForeignKey(nameof(PatientId))]
        public Patient Patient { get; set; } = null!;

        [ForeignKey(nameof(DoctorId))]
        public Doctor Doctor { get; set; } = null!;

        [ForeignKey(nameof(ServiceId))]
        public Service Service { get; set; } = null!;

        [ForeignKey(nameof(RoomId))]
        public Room Room { get; set; } = null!;

        public MedicalRecord? MedicalRecord { get; set; }
        public DoctorNote? DoctorNoteEntry { get; set; }
        public Payment? Payment { get; set; }
        public Review? Review { get; set; }
    }
}
