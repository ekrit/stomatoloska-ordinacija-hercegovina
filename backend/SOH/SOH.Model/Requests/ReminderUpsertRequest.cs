using System;
using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class ReminderUpsertRequest
    {
        [Required]
        public int PatientId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Type { get; set; } = string.Empty;

        [Required]
        [MaxLength(500)]
        public string Message { get; set; } = string.Empty;

        [Required]
        public DateTime ScheduledFor { get; set; }
    }
}
