using System;

namespace SOH.Model.Responses
{
    public class AuthResponse
    {
        public string Token { get; set; } = string.Empty;
        public DateTime ExpiresAt { get; set; }
        public UserResponse User { get; set; } = new UserResponse();
    }
}
