namespace SOH.WebAPI.Authorization;

/// <summary>
/// JWT role claims must match seeded <see cref="SOH.Services.Database.Role"/> names.
/// </summary>
public static class RoleNames
{
    public const string Administrator = "Administrator";

    /// <summary>JWT/database role for clinic patients (public registration).</summary>
    public const string Patient = "Patient";

    /// <summary>JWT/database role for dentists (stomatologists).</summary>
    public const string Doctor = "Doctor";

    /// <summary>Legacy name; same claim value as <see cref="Patient"/>.</summary>
    public const string User = Patient;
}
