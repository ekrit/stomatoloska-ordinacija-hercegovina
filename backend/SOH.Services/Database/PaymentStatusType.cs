using System.ComponentModel.DataAnnotations;

namespace SOH.Services.Database
{
    /// <summary>
    /// Administrable reference data for payment statuses. Same arrangement as
    /// <see cref="AppointmentStatusType"/>: <see cref="PaymentStatus"/> remains
    /// the authority for payment logic, while this table makes the codebook
    /// maintainable through the API and the desktop app.
    /// </summary>
    public class PaymentStatusType
    {
        /// <summary>Matches the <see cref="PaymentStatus"/> value.</summary>
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(200)]
        public string? Description { get; set; }
    }
}
