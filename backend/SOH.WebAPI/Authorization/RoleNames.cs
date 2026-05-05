namespace SOH.WebAPI.Authorization;

/// <summary>
/// JWT role claims must match seeded <see cref="SOH.Services.Database.Role"/> names.
/// </summary>
public static class RoleNames
{
    public const string Administrator = "Administrator";
    public const string User = "User";
}
