using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class CityUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(200)]
        public string? Address { get; set; }

        [MaxLength(50)]
        public string? ContactPhone { get; set; }

        [MaxLength(100)]
        public string? ContactEmail { get; set; }

        [MaxLength(100)]
        public string? WorkingHours { get; set; }
    }
} 