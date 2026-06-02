using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class ChangePasswordRequest
    {
        [Required]
        public string OldPassword { get; set; } = string.Empty;

        [Required]
        [MinLength(4)]
        public string NewPassword { get; set; } = string.Empty;
    }
}
