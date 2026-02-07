using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class OrderItemUpsertRequest
    {
        [Required]
        public int OrderId { get; set; }

        [Required]
        public int ProductId { get; set; }

        [Required]
        public int Quantity { get; set; }

        [Required]
        public decimal UnitPrice { get; set; }
    }
}
