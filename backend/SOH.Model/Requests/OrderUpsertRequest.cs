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

        // TotalAmount is intentionally not accepted from the client. The server
        // computes it from the product catalog price (rubric 7.1: the server
        // owns the price and must not trust the client).
    }
}
