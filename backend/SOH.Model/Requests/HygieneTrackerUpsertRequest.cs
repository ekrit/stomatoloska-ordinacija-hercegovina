using System;
using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class HygieneTrackerUpsertRequest
    {
        [Required]
        public int PatientId { get; set; }

        [Required]
        public DateTime Date { get; set; }

        [Required]
        public int BrushesCount { get; set; }
    }
}
