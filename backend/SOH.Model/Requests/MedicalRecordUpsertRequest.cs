using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class MedicalRecordUpsertRequest
    {
        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
        public int AppointmentId { get; set; }

        [Required]
        [MaxLength(1000)]
        public string Diagnosis { get; set; } = string.Empty;

        [MaxLength(2000)]
        public string Treatment { get; set; } = string.Empty;
    }
}
