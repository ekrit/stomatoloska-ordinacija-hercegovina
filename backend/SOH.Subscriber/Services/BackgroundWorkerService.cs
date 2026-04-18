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
            try
            {
                using var bus = RabbitHutch.CreateBus(
                    $"host={_host};virtualHost={_virtualhost};username={_username};password={_password}");

                bus.PubSub.Subscribe<AppointmentReminderMessage>(
                    "Appointment_Reminders",
                    HandleAppointmentReminder);

                _logger.LogInformation("Subscribed to appointment reminders.");
                await Task.Delay(Timeout.Infinite, stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation("Subscriber stopping.");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in RabbitMQ listener.");
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