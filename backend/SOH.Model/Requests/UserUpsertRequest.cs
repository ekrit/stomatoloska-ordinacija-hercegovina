using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class UserUpsertRequest
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
        
        public bool IsActive { get; set; } = true;
        
        // Set when creating a user or changing a password.
        [MinLength(4)]
        public string? Password { get; set; }

        // Required only when a user changes their OWN password; the server
        // verifies it before applying the new password. Ignored for admins
        // editing another user.
        public string? OldPassword { get; set; }
        
        // Collection of role IDs to assign to the user
        public List<int> RoleIds { get; set; } = new List<int>();
    }
} 