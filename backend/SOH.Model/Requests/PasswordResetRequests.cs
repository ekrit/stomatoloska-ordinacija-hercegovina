using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    /// <summary>Starts a reset for whoever owns this username or e-mail.</summary>
    public class PasswordResetStartRequest
    {
        [Required(ErrorMessage = "Unesite korisničko ime ili e-mail.")]
        [MaxLength(100)]
        public string UsernameOrEmail { get; set; } = string.Empty;
    }

    /// <summary>Completes a reset with the one-time code from the e-mail.</summary>
    public class PasswordResetCompleteRequest
    {
        [Required(ErrorMessage = "Unesite korisničko ime ili e-mail.")]
        [MaxLength(100)]
        public string UsernameOrEmail { get; set; } = string.Empty;

        [Required(ErrorMessage = "Unesite kod za reset lozinke.")]
        [MaxLength(20)]
        public string Code { get; set; } = string.Empty;

        [Required(ErrorMessage = "Unesite novu lozinku.")]
        [MinLength(8, ErrorMessage = "Nova lozinka mora imati najmanje 8 znakova.")]
        [MaxLength(100)]
        public string NewPassword { get; set; } = string.Empty;
    }
}
