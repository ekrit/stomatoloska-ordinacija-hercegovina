using System;
using SOH.Model.Enums;

namespace SOH.Model.Responses
{
    public class PaymentResponse
    {
        public int Id { get; set; }
        public int AppointmentId { get; set; }
        public decimal Amount { get; set; }
        public string Method { get; set; } = string.Empty;
        public PaymentStatus Status { get; set; }
        public string? TransactionRef { get; set; }
        public string? PayPalOrderId { get; set; }
        public DateTime CreatedAt { get; set; }

        /// <summary>Business currency of <see cref="Amount"/> (BAM).</summary>
        public string Currency { get; set; } = string.Empty;

        /// <summary>What the provider was charged, after conversion.</summary>
        public decimal? ChargedAmount { get; set; }

        /// <summary>Currency of <see cref="ChargedAmount"/> (EUR for PayPal).</summary>
        public string? ChargedCurrency { get; set; }

        /// <summary>When the capture completed; null until paid.</summary>
        public DateTime? PaidAt { get; set; }
    }
}
