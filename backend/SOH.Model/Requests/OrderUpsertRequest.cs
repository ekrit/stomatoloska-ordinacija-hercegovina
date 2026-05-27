using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class OrderUpsertRequest
    {
        [Required]
        public int PatientId { get; set; }

        [Required]
        public int ProductId { get; set; }

        [Range(1, 1000)]
        public int Quantity { get; set; } = 1;

        [Required]
        public decimal TotalAmount { get; set; }
    }
}
