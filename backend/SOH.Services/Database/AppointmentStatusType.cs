using System.ComponentModel.DataAnnotations;

namespace SOH.Services.Database
{
    /// <summary>
    /// Administrable reference data for appointment statuses.
    /// <para>
    /// <b>The enum stays the authority.</b> <see cref="AppointmentStatus"/> drives
    /// the state machine — which transitions are legal, which statuses hold a
    /// slot — and that logic must not depend on rows an administrator can edit.
    /// This table exists so the statuses the project uses are maintainable
    /// reference data with full CRUD and a desktop screen, as the course
    /// requires: the administrator owns the label and description shown in the
    /// UI, while <see cref="Id"/> stays pinned to the enum value.
    /// </para>
    /// <para>
    /// Deleting a row is refused while appointments still carry that status, so
    /// the codebook cannot drift away from the data.
    /// </para>
    /// </summary>
    public class AppointmentStatusType
    {
        /// <summary>Matches the <see cref="AppointmentStatus"/> value.</summary>
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(200)]
        public string? Description { get; set; }
    }
}
