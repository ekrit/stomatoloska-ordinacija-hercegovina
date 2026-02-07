using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class ProductUpsertRequest
    {
        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(500)]
        public string Description { get; set; } = string.Empty;

        [Required]
        public decimal Price { get; set; }

        [MaxLength(100)]
        public string Category { get; set; } = string.Empty;
    }
}
