using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SOH.Services.Database
{
    /// <summary>
    /// One row per appointment status change: who changed it, when, from which
    /// status to which, and why. The generic ActivityLog recorded only that an
    /// appointment was updated, so a cancellation or a rejection left no record
    /// of its reason or of the transition it made.
    /// </summary>
    public class AppointmentStatusHistory
    {
        [Key]
        public int Id { get; set; }

        public int AppointmentId { get; set; }

        public AppointmentStatus FromStatus { get; set; }

        public AppointmentStatus ToStatus { get; set; }

        /// <summary>Why the change was made; required for decline and cancel.</summary>
        [MaxLength(2000)]
        public string? Reason { get; set; }

        /// <summary>Actor; null only for system-driven transitions.</summary>
        public int? ChangedByUserId { get; set; }

        [MaxLength(100)]
        public string? ChangedByUsername { get; set; }

        public DateTime ChangedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey(nameof(AppointmentId))]
        public Appointment Appointment { get; set; } = null!;
    }
}
