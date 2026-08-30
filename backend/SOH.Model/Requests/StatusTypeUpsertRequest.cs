using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    /// <summary>
    /// Shared shape for the status codebooks. Id is supplied on create because
    /// it must line up with the corresponding enum value.
    /// </summary>
    public class StatusTypeUpsertRequest
    {
        [Range(1, int.MaxValue, ErrorMessage = "Šifra statusa mora biti pozitivan broj.")]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(200)]
        public string? Description { get; set; }
    }
}
