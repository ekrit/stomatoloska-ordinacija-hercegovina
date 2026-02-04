using System;
using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class ReportUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Type { get; set; } = string.Empty;

        [Required]
        public DateTime GeneratedAt { get; set; }

        [Required]
        [MaxLength(300)]
        public string FilePath { get; set; } = string.Empty;
    }
}
