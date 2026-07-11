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

                    _logger.LogInformation("Subscribed to appointment reminders.");
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