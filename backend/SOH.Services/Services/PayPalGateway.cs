using System.Globalization;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using SOH.Model.Exceptions;
using SOH.Services.Interfaces;

namespace SOH.Services.Services;

/// <summary>
/// Thin PayPal Orders v2 client for the sandbox. Reads client id/secret and
/// base URL from configuration (PAYPAL__* via .env). The server is always the
/// source of truth for the amount; callers never pass money in from the UI.
/// </summary>
public class PayPalGateway : IPayPalGateway
{
    private readonly HttpClient _http;
    private readonly string _clientId;
    private readonly string _clientSecret;
    private readonly string _webhookId;

    public PayPalGateway(HttpClient http, IConfiguration configuration)
    {
        _http = http;
        var section = configuration.GetSection("PAYPAL");
        var baseUrl = section["BASE_URL"] ?? "https://api-m.sandbox.paypal.com";
        _http.BaseAddress = new Uri(baseUrl.TrimEnd('/') + "/");
        _clientId = section["CLIENT_ID"] ?? string.Empty;
        _clientSecret = section["CLIENT_SECRET"] ?? string.Empty;
        _webhookId = section["WEBHOOK_ID"] ?? string.Empty;
    }

    private bool IsConfigured =>
        !string.IsNullOrWhiteSpace(_clientId) && !string.IsNullOrWhiteSpace(_clientSecret);

    private void EnsureConfigured()
    {
        if (!IsConfigured)
        {
            throw new BusinessException(
                "PayPal is not configured. Set PAYPAL__CLIENT_ID and PAYPAL__CLIENT_SECRET in .env.");
        }
    }

    private async Task<string> GetAccessTokenAsync(CancellationToken cancellationToken)
    {
        EnsureConfigured();
        var basic = Convert.ToBase64String(Encoding.UTF8.GetBytes($"{_clientId}:{_clientSecret}"));
        using var req = new HttpRequestMessage(HttpMethod.Post, "v1/oauth2/token");
        req.Headers.Authorization = new AuthenticationHeaderValue("Basic", basic);
        req.Content = new FormUrlEncodedContent(new[]
        {
            new KeyValuePair<string, string>("grant_type", "client_credentials"),
        });

        using var resp = await _http.SendAsync(req, cancellationToken);
        var body = await resp.Content.ReadAsStringAsync(cancellationToken);
        if (!resp.IsSuccessStatusCode)
        {
            throw new BusinessException($"PayPal auth failed ({(int)resp.StatusCode}): {body}");
        }

        using var doc = JsonDocument.Parse(body);
        return doc.RootElement.GetProperty("access_token").GetString()
            ?? throw new BusinessException("PayPal auth returned no access_token.");
    }

    public async Task<PayPalOrderResult> CreateOrderAsync(decimal amountEur, string returnUrl, string cancelUrl, CancellationToken cancellationToken = default)
    {
        var token = await GetAccessTokenAsync(cancellationToken);

        var payload = new
        {
            intent = "CAPTURE",
            purchase_units = new[]
            {
                new
                {
                    amount = new
                    {
                        currency_code = "EUR",
                        value = amountEur.ToString("F2", CultureInfo.InvariantCulture),
                    },
                },
            },
            application_context = new
            {
                return_url = returnUrl,
                cancel_url = cancelUrl,
                user_action = "PAY_NOW",
                shipping_preference = "NO_SHIPPING",
            },
        };

        using var req = new HttpRequestMessage(HttpMethod.Post, "v2/checkout/orders")
        {
            Content = JsonContent.Create(payload),
        };
        req.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);

        using var resp = await _http.SendAsync(req, cancellationToken);
        var body = await resp.Content.ReadAsStringAsync(cancellationToken);
        if (!resp.IsSuccessStatusCode)
        {
            throw new BusinessException($"PayPal create order failed ({(int)resp.StatusCode}): {body}");
        }

        using var doc = JsonDocument.Parse(body);
        var root = doc.RootElement;
        var orderId = root.GetProperty("id").GetString() ?? string.Empty;
        var approvalUrl = string.Empty;
        if (root.TryGetProperty("links", out var links))
        {
            foreach (var link in links.EnumerateArray())
            {
                if (link.TryGetProperty("rel", out var rel) &&
                    string.Equals(rel.GetString(), "approve", StringComparison.OrdinalIgnoreCase))
                {
                    approvalUrl = link.GetProperty("href").GetString() ?? string.Empty;
                    break;
                }
            }
        }

        return new PayPalOrderResult(orderId, approvalUrl);
    }

    public async Task<string?> CaptureOrderAsync(string orderId, CancellationToken cancellationToken = default)
    {
        var token = await GetAccessTokenAsync(cancellationToken);

        using var req = new HttpRequestMessage(HttpMethod.Post, $"v2/checkout/orders/{orderId}/capture")
        {
            Content = new StringContent("{}", Encoding.UTF8, "application/json"),
        };
        req.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);

        using var resp = await _http.SendAsync(req, cancellationToken);
        var body = await resp.Content.ReadAsStringAsync(cancellationToken);
        if (!resp.IsSuccessStatusCode)
        {
            throw new BusinessException($"PayPal capture failed ({(int)resp.StatusCode}): {body}");
        }

        using var doc = JsonDocument.Parse(body);
        var root = doc.RootElement;
        var status = root.TryGetProperty("status", out var s) ? s.GetString() : null;
        if (!string.Equals(status, "COMPLETED", StringComparison.OrdinalIgnoreCase))
        {
            throw new BusinessException($"PayPal capture not completed (status: {status}).");
        }

        // Dig out the capture id used later for refunds.
        if (root.TryGetProperty("purchase_units", out var units))
        {
            foreach (var unit in units.EnumerateArray())
            {
                if (unit.TryGetProperty("payments", out var payments) &&
                    payments.TryGetProperty("captures", out var captures))
                {
                    foreach (var cap in captures.EnumerateArray())
                    {
                        if (cap.TryGetProperty("id", out var capId))
                        {
                            return capId.GetString();
                        }
                    }
                }
            }
        }

        return null;
    }

    public async Task RefundCaptureAsync(string captureId, CancellationToken cancellationToken = default)
    {
        var token = await GetAccessTokenAsync(cancellationToken);

        using var req = new HttpRequestMessage(HttpMethod.Post, $"v2/payments/captures/{captureId}/refund")
        {
            Content = new StringContent("{}", Encoding.UTF8, "application/json"),
        };
        req.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);

        using var resp = await _http.SendAsync(req, cancellationToken);
        var body = await resp.Content.ReadAsStringAsync(cancellationToken);
        if (!resp.IsSuccessStatusCode)
        {
            throw new BusinessException($"PayPal refund failed ({(int)resp.StatusCode}): {body}");
        }
    }

    public bool VerifyWebhook(string? transmissionId, string? transmissionTime, string? certUrl, string? authAlgo, string? transmissionSig, string? webhookId, string rawBody)
    {
        // Sandbox-friendly verification: when no webhook id is configured we
        // accept the event (dev convenience). When configured we require the
        // header webhook id to match ours. A full crypto verification against
        // PayPal's /v1/notifications/verify-webhook-signature can replace this
        // when going to production.
        if (string.IsNullOrWhiteSpace(_webhookId))
        {
            return true;
        }

        return !string.IsNullOrWhiteSpace(webhookId) &&
               string.Equals(webhookId, _webhookId, StringComparison.Ordinal);
    }
}
