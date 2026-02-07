using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SOH.Services.Database
{
    public class Payment
    {
        [Key]
        public int Id { get; set; }

        public int AppointmentId { get; set; }

        [Precision(18, 2)]
        public decimal Amount { get; set; }

        [Required]
        [MaxLength(50)]
        public string Method { get; set; } = string.Empty;

        public PaymentStatus Status { get; set; }

        [MaxLength(100)]
        public string? TransactionRef { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey(nameof(AppointmentId))]
        public Appointment Appointment { get; set; } = null!;
    }
}
