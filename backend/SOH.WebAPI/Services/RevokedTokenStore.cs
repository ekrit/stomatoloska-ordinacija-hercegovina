using System.Collections.Concurrent;

namespace SOH.WebAPI.Services;

/// <summary>
/// Thread-safe in-memory implementation. Expired entries are pruned lazily on
/// every revoke and every lookup, so the dictionary never grows without bound
/// even though the API runs for days at a time.
/// </summary>
public sealed class RevokedTokenStore : IRevokedTokenStore
{
    private readonly ConcurrentDictionary<string, DateTimeOffset> _revoked = new();

    public void Revoke(string jti, DateTimeOffset expiresAt)
    {
        if (string.IsNullOrWhiteSpace(jti)) return;
        Prune();
        _revoked[jti] = expiresAt;
    }

    public bool IsRevoked(string jti)
    {
        if (string.IsNullOrWhiteSpace(jti)) return false;
        Prune();
        return _revoked.ContainsKey(jti);
    }

    private void Prune()
    {
        var now = DateTimeOffset.UtcNow;
        foreach (var pair in _revoked)
        {
            if (pair.Value <= now)
            {
                _revoked.TryRemove(pair.Key, out _);
            }
        }
    }
}
