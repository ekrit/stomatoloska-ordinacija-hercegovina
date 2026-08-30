using System;
using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class HygieneTrackerUpsertRequest
    {
        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
        public int PatientId { get; set; }

        [Required]
        public DateTime Date { get; set; }

        // [Required] on a non-nullable int accepts 0, and nothing capped the
        // upper end, so any number at all could be logged for a single day.
        [Range(0, 20, ErrorMessage = "Broj pranja zuba mora biti između 0 i 20.")]
        public int BrushesCount { get; set; }
    }
}
