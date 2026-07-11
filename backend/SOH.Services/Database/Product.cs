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

        public int ProductCategoryId { get; set; }
        public ProductCategory ProductCategory { get; set; } = null!;

        public byte[]? Picture { get; set; }

        public ICollection<Order> Orders { get; set; } = new List<Order>();
    }
}
