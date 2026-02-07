using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class ServiceUpsertRequest
    {
        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(500)]
        public string Description { get; set; } = string.Empty;

        [Required]
        public decimal Price { get; set; }

        [Required]
        public int DurationMinutes { get; set; }
    }
}
