namespace SOH.WebAPI.Services;

/// <summary>
/// Tracks JWT identifiers (jti claim) of tokens the user logged out of so
/// they cannot be re-used until they naturally expire. Backed by in-memory
/// state because the API runs as a single instance per environment; replace
/// with a shared cache (Redis) only when we go multi-node.
/// </summary>
public interface IRevokedTokenStore
{
    /// <summary>Marks the jti as logged out until at least <paramref name="expiresAt"/>.</summary>
    void Revoke(string jti, DateTimeOffset expiresAt);

    /// <summary>Returns true when the token must be rejected.</summary>
    bool IsRevoked(string jti);
}
