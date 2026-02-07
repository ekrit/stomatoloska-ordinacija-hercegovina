using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SOH.Services.Database
{
    public class DoctorNote
    {
        [Key]
        public int Id { get; set; }

        public int AppointmentId { get; set; }

        [Required]
        [MaxLength(2000)]
        public string Note { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey(nameof(AppointmentId))]
        public Appointment Appointment { get; set; } = null!;
    }
}
