using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class DoctorNoteUpsertRequest
    {
        [Required]
        public int AppointmentId { get; set; }

        [Required]
        [MaxLength(2000)]
        public string Note { get; set; } = string.Empty;
    }
}
