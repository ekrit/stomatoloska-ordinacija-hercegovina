using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class UserRegisterRequest
    {
        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string LastName { get; set; } = string.Empty;

        public byte[]? Picture { get; set; }

        [Required]
        [MaxLength(100)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Username { get; set; } = string.Empty;

        [Phone]
        [MaxLength(20)]
        public string? PhoneNumber { get; set; }

        [Required]
        public int GenderId { get; set; }

        [Required]
        public int CityId { get; set; }

        [Required]
        [MinLength(4)]
        public string Password { get; set; } = string.Empty;
    }
}
