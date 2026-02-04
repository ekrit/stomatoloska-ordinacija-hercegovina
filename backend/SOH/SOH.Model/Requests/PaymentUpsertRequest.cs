using System.ComponentModel.DataAnnotations;
using SOH.Model.Enums;

namespace SOH.Model.Requests
{
    public class PaymentUpsertRequest
    {
        [Required]
        public int AppointmentId { get; set; }

        [Required]
        public decimal Amount { get; set; }

        [Required]
        [MaxLength(50)]
        public string Method { get; set; } = string.Empty;

        public PaymentStatus Status { get; set; }

        [MaxLength(100)]
        public string? TransactionRef { get; set; }
    }
}
