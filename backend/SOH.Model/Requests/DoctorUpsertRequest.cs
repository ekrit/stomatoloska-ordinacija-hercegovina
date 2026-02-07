using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class DoctorUpsertRequest
    {
        [Required]
        public int UserId { get; set; }

        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string LastName { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Specialization { get; set; } = string.Empty;

        public decimal Rating { get; set; }
    }
}
