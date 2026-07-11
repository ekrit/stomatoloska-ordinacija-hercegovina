using System.ComponentModel.DataAnnotations;

namespace SOH.Services.Database
{
    public class ActivityLog
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Action { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string EntityName { get; set; } = string.Empty;

        [MaxLength(50)]
        public string? EntityId { get; set; }

        // Actor: who performed the action (null for system/anonymous events).
        public int? UserId { get; set; }
        public User? User { get; set; }

        [MaxLength(100)]
        public string? Username { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
