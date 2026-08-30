using System;
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

        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
        public int GenderId { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Odaberite ispravnu vrijednost.")]
        public int CityId { get; set; }

        [Required]
        [MinLength(4)]
        public string Password { get; set; } = string.Empty;

        /// <summary>
        /// Real date of birth for the clinic chart. Registration previously
        /// left this out and the server stored the registration date instead,
        /// so every new patient's birthday was the day they signed up.
        /// </summary>
        [Required]
        public DateTime DateOfBirth { get; set; }
    }
}
