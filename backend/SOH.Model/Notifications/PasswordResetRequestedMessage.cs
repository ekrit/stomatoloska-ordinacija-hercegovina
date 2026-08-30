using System;

namespace SOH.Model.Notifications
{
    /// <summary>
    /// Carries a one-time password-reset code to the notification worker, which
    /// delivers it by e-mail. The code never travels back to the caller in the
    /// HTTP response: whoever asks for a reset must prove they can read the
    /// account's inbox.
    /// </summary>
    public class PasswordResetRequestedMessage
    {
        public int UserId { get; set; }
        public string Email { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;

        /// <summary>The plaintext code; only its hash is stored server-side.</summary>
        public string Code { get; set; } = string.Empty;

        public DateTime ExpiresAtUtc { get; set; }
        public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    }
}
