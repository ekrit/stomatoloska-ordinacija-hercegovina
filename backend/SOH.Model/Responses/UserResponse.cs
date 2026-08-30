using System;
using System.Collections.Generic;

namespace SOH.Model.Responses
{
    public class UserResponse
    {
        public int Id { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        /// <summary>
        /// Full image bytes. Populated on the details endpoint only; list rows
        /// leave this null and set <see cref="HasPicture"/> instead. Fetch the
        /// image from <c>GET /Users/{id}/picture</c>.
        /// </summary>
        public byte[]? Picture { get; set; }

        /// <summary>True when a picture exists, whether or not it is included.</summary>
        public bool HasPicture { get; set; }

        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? LastLoginAt { get; set; }
        public string? PhoneNumber { get; set; }
        
        // Gender and City information
        public int GenderId { get; set; }
        public string GenderName { get; set; } = string.Empty;
        public int CityId { get; set; }
        public string CityName { get; set; } = string.Empty;
        
        // Collection of roles assigned to the user
        public List<RoleResponse> Roles { get; set; } = new List<RoleResponse>();
    }
} 