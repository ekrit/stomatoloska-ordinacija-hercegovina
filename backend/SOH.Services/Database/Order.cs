using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SOH.Services.Database
{
    public class Order
    {
        [Key]
        public int Id { get; set; }

        public int PatientId { get; set; }

        public int ProductId { get; set; }

        public int Quantity { get; set; } = 1;

        [Precision(18, 2)]
        public decimal TotalAmount { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey(nameof(PatientId))]
        public Patient Patient { get; set; } = null!;

        [ForeignKey(nameof(ProductId))]
        public Product Product { get; set; } = null!;
    }
}
