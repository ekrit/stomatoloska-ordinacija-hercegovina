using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class ActivityLogUpsertRequest
    {
        [Required]
        [MaxLength(100)]
        public string Action { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string EntityName { get; set; } = string.Empty;

        [MaxLength(50)]
        public string? EntityId { get; set; }
    }
}
