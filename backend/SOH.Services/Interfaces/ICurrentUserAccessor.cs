namespace SOH.Services.Interfaces
{
    /// <summary>
    /// Exposes the authenticated caller to the service layer without coupling
    /// it to ASP.NET Core. Implemented in the WebAPI over IHttpContextAccessor.
    /// Both values are null for anonymous or out-of-request work.
    /// </summary>
    public interface ICurrentUserAccessor
    {
        int? UserId { get; }
        string? Username { get; }
    }
}
