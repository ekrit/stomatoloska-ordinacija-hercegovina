using EasyNetQ;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using SOH.Subscriber.Interfaces;
using SOH.Model.Notifications;

namespace SOH.Subscriber.Services
{
    public class BackgroundWorkerService : BackgroundService
    {
        private readonly ILogger<BackgroundWorkerService> _logger;
        private readonly IEmailSenderService _emailSender;
        private readonly string _host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
        private readonly string _username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
        private readonly string _password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
        private readonly string _virtualhost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";
        private readonly string[] _recipients =
            (Environment.GetEnvironmentVariable("APPOINTMENT_REMINDER_RECIPIENTS") ?? string.Empty)
                .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

        public BackgroundWorkerService(
            ILogger<BackgroundWorkerService> logger,
            IEmailSenderService emailSender)
        {
            _logger = logger;
            _emailSender = emailSender;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            // The broker usually starts alongside this container and may not
            // accept connections yet, so keep retrying with exponential
            // backoff — a worker that gives up after one failed subscribe
            // would silently stay deaf for its whole lifetime.
            var delay = TimeSpan.FromSeconds(1);
            var maxDelay = TimeSpan.FromSeconds(30);

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using var bus = RabbitHutch.CreateBus(
                        $"host={_host};virtualHost={_virtualhost};username={_username};password={_password}");

                    bus.PubSub.Subscribe<AppointmentReminderMessage>(
                        "Appointment_Reminders",
                        HandleAppointmentReminder);

                    bus.PubSub.Subscribe<PasswordResetRequestedMessage>(
                        "Password_Resets",
                        HandlePasswordReset);

                    _logger.LogInformation("Subscribed to appointment reminders and password resets.");
                    delay = TimeSpan.FromSeconds(1);
                    await Task.Delay(Timeout.Infinite, stoppingToken);
                }
                catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
                {
                    _logger.LogInformation("Subscriber stopping.");
                    return;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "RabbitMQ listener failed; retrying in {Delay}.", delay);
                    try
                    {
                        await Task.Delay(delay, stoppingToken);
                    }
                    catch (OperationCanceledException)
                    {
                        return;
                    }
                    delay = TimeSpan.FromTicks(Math.Min(delay.Ticks * 2, maxDelay.Ticks));
                }
            }
        }

        /// <summary>
        /// Mails the one-time reset code to the account's own address — that is
        /// the whole point of the flow, so unlike the reminder recipients this
        /// does not read a configured list. The code is never logged.
        /// </summary>
        private async Task HandlePasswordReset(PasswordResetRequestedMessage message)
        {
            _logger.LogInformation(
                "Password reset requested for user {UserId}; code expires {ExpiresAtUtc:o}",
                message.UserId,
                message.ExpiresAtUtc);

            if (string.IsNullOrWhiteSpace(message.Email))
            {
                _logger.LogWarning("No e-mail address for user {UserId}; reset code not delivered.", message.UserId);
                return;
            }

            var subject = "Reset lozinke - Stomatološka ordinacija";
            var body =
                $"Poštovani/a {message.FirstName},\n\n" +
                $"Vaš jednokratni kod za reset lozinke je: {message.Code}\n" +
                $"Kod vrijedi do {message.ExpiresAtUtc:HH:mm} UTC ({message.ExpiresAtUtc:dd.MM.yyyy.}).\n\n" +
                "Ako niste tražili reset lozinke, zanemarite ovu poruku - vaša lozinka ostaje nepromijenjena.";

            try
            {
                await _emailSender.SendEmailAsync(message.Email, subject, body);
                _logger.LogInformation("Password reset e-mail sent for user {UserId}", message.UserId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to send password reset e-mail for user {UserId}", message.UserId);
            }
        }

        private async Task HandleAppointmentReminder(AppointmentReminderMessage message)
        {
            var log = $"Appointment reminder received. AppointmentId={message.AppointmentId}, " +
                      $"PatientId={message.PatientId}, DoctorId={message.DoctorId}, " +
                      $"ServiceId={message.ServiceId}, StartTimeUtc={message.StartTimeUtc:o}, " +
                      $"ClientComplaint={message.ClientComplaint}";
            _logger.LogInformation(log);

            if (_recipients.Length == 0)
            {
                return;
            }

            var subject = $"Appointment reminder #{message.AppointmentId}";
            var body = $"Appointment #{message.AppointmentId} is scheduled at {message.StartTimeUtc:u}.\n" +
                       $"PatientId: {message.PatientId}\nDoctorId: {message.DoctorId}\n" +
                       $"ServiceId: {message.ServiceId}\nComplaint: {message.ClientComplaint ?? "-"}";

            foreach (var email in _recipients)
            {
                try
                {
                    await _emailSender.SendEmailAsync(email, subject, body);
                    _logger.LogInformation("Appointment reminder email sent to {Email}", email);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to send reminder email to {Email}", email);
                }
            }
        }
    }
}