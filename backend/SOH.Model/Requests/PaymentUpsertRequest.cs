using System.ComponentModel.DataAnnotations;
using SOH.Model.Enums;

namespace SOH.Model.Requests
{
    public class PaymentUpsertRequest
    {
        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
        public int AppointmentId { get; set; }

        [Range(0.01, 1000000, ErrorMessage = "Iznos mora biti veći od nule.")]
        public decimal Amount { get; set; }

        [Required]
        [MaxLength(50)]
        public string Method { get; set; } = string.Empty;

        public PaymentStatus Status { get; set; }

        [MaxLength(100)]
        public string? TransactionRef { get; set; }
    }
}
