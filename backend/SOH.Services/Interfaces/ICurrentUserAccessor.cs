namespace SOH.Services.Interfaces
{
    /// <summary>
    /// Exposes the authenticated caller to the service layer without coupling
    /// it to ASP.NET Core. Implemented in the WebAPI over IHttpContextAccessor.
    /// Values are null/false for anonymous or out-of-request work.
    /// </summary>
    public interface ICurrentUserAccessor
    {
        int? UserId { get; }
        string? Username { get; }

        /// <summary>True when the caller's JWT carries the Administrator role.</summary>
        bool IsAdministrator { get; }

        /// <summary>True when the caller's JWT carries the Doctor role.</summary>
        bool IsDoctor { get; }

        /// <summary>
        /// True for an authenticated caller who is neither administrator nor
        /// doctor. Business rules use it to bind write operations to the
        /// identity in the token instead of an id sent by the client.
        /// </summary>
        bool IsPatient { get; }
    }
}
