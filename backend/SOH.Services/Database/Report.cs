using System.ComponentModel.DataAnnotations;

namespace SOH.Services.Database
{
    public class Report
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Type { get; set; } = string.Empty;

        public DateTime GeneratedAt { get; set; } = DateTime.UtcNow;

        [Required]
        [MaxLength(300)]
        public string FilePath { get; set; } = string.Empty;
    }
}
