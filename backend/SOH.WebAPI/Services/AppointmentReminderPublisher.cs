using EasyNetQ;
using SOH.Model.Notifications;

namespace SOH.WebAPI.Services
{
    public class AppointmentReminderPublisher : IAppointmentReminderPublisher
    {
        private readonly ILogger<AppointmentReminderPublisher> _logger;
        private readonly string _connectionString;

        public AppointmentReminderPublisher(ILogger<AppointmentReminderPublisher> logger)
        {
            _logger = logger;
            var host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
            var username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
            var password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
            var virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";
            _connectionString = $"host={host};virtualHost={virtualHost};username={username};password={password}";
        }

        public async Task PublishAsync(
            AppointmentReminderMessage message,
            CancellationToken cancellationToken = default)
        {
            try
            {
                using var bus = RabbitHutch.CreateBus(_connectionString);
                await bus.PubSub.PublishAsync(message, cancellationToken);
                _logger.LogInformation(
                    "Appointment reminder published for appointment {AppointmentId}",
                    message.AppointmentId);
            }
            catch (Exception ex)
            {
                _logger.LogWarning(
                    ex,
                    "Failed to publish appointment reminder for appointment {AppointmentId}",
                    message.AppointmentId);
            }
        }
    }
}
