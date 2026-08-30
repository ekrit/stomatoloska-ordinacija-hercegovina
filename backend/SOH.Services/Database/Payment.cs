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

        /// <summary>Amount in the clinic's business currency (see <see cref="Currency"/>).</summary>
        [Precision(18, 2)]
        public decimal Amount { get; set; }

        /// <summary>
        /// Business currency of <see cref="Amount"/>. Prices across the catalog,
        /// booking and orders are in KM, so this is BAM.
        /// </summary>
        [Required]
        [MaxLength(3)]
        public string Currency { get; set; } = MoneyPolicy.BusinessCurrency;

        /// <summary>
        /// What the provider was actually asked to charge, converted from
        /// <see cref="Amount"/>. PayPal does not settle in BAM, so the charge
        /// happens in EUR and both sides of the conversion are kept: without
        /// this the record could not say what the patient really paid.
        /// </summary>
        [Precision(18, 2)]
        public decimal? ChargedAmount { get; set; }

        /// <summary>Currency of <see cref="ChargedAmount"/> (EUR for PayPal).</summary>
        [MaxLength(3)]
        public string? ChargedCurrency { get; set; }

        /// <summary>When the capture completed. Null until the payment is Paid.</summary>
        public DateTime? PaidAt { get; set; }

        [Required]
        [MaxLength(50)]
        public string Method { get; set; } = string.Empty;

        public PaymentStatus Status { get; set; }

        [MaxLength(100)]
        public string? TransactionRef { get; set; }

        [MaxLength(100)]
        public string? PayPalOrderId { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey(nameof(AppointmentId))]
        public Appointment Appointment { get; set; } = null!;
    }
}
