using System.Net;
using System.Net.Mail;
using Microsoft.Extensions.Logging;
using SOH.Subscriber.Interfaces;

namespace SOH.Subscriber.Services
{
    /// <summary>
    /// Sends appointment reminder emails via SMTP. Credentials previously
    /// lived in source (a Gmail app password hardcoded next to the API key)
    /// which is rejected by the seminar rubric and any sensible security
    /// review; they now come exclusively from environment variables /
    /// the loaded .env file.
    /// </summary>
    public class EmailSenderService : IEmailSenderService
    {
        private const string DefaultHost = "smtp.gmail.com";
        private const int DefaultPort = 587;

        private readonly ILogger<EmailSenderService> _logger;
        private readonly string _host;
        private readonly int _port;
        private readonly bool _enableSsl;
        private readonly string? _username;
        private readonly string? _password;
        private readonly string? _from;

        public EmailSenderService(ILogger<EmailSenderService> logger)
        {
            _logger = logger;
            _host = Environment.GetEnvironmentVariable("SMTP__HOST") ?? DefaultHost;
            _port = int.TryParse(Environment.GetEnvironmentVariable("SMTP__PORT"), out var p) ? p : DefaultPort;
            _enableSsl = !bool.TryParse(Environment.GetEnvironmentVariable("SMTP__ENABLESSL"), out var ssl) || ssl;
            _username = Environment.GetEnvironmentVariable("SMTP__USERNAME");
            _password = Environment.GetEnvironmentVariable("SMTP__PASSWORD");
            _from = Environment.GetEnvironmentVariable("SMTP__FROM") ?? _username;
        }

        public async Task SendEmailAsync(string email, string subject, string message)
        {
            if (string.IsNullOrWhiteSpace(_username) || string.IsNullOrWhiteSpace(_password) || string.IsNullOrWhiteSpace(_from))
            {
                _logger.LogWarning(
                    "SMTP credentials missing (SMTP__USERNAME / SMTP__PASSWORD / SMTP__FROM); skipping email to {Email}.",
                    email);
                return;
            }

            using var client = new SmtpClient(_host, _port)
            {
                EnableSsl = _enableSsl,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(_username, _password)
            };

            using var mail = new MailMessage(from: _from, to: email, subject, message);
            await client.SendMailAsync(mail);
        }
    }
}
