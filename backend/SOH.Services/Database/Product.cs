using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace SOH.Services.Database
{
    public class Product
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(500)]
        public string Description { get; set; } = string.Empty;

        [Precision(18, 2)]
        public decimal Price { get; set; }

        [MaxLength(100)]
        public string Category { get; set; } = string.Empty;

        public ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
    }
}
