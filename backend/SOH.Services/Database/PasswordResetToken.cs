using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SOH.Services.Database
{
    /// <summary>
    /// A one-time code that lets a user who cannot sign in set a new password.
    /// <para>
    /// Only the hash of the code is stored, for the same reason passwords are
    /// hashed: a leaked database must not hand out working reset codes. The row
    /// is single-use (<see cref="UsedAt"/>) and short-lived
    /// (<see cref="ExpiresAt"/>).
    /// </para>
    /// </summary>
    public class PasswordResetToken
    {
        [Key]
        public int Id { get; set; }

        public int UserId { get; set; }

        [Required]
        [MaxLength(200)]
        public string CodeHash { get; set; } = string.Empty;

        public DateTime ExpiresAt { get; set; }

        public DateTime? UsedAt { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey(nameof(UserId))]
        public User User { get; set; } = null!;
    }
}
