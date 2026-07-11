using EasyNetQ;
using SOH.Model.Notifications;

namespace SOH.WebAPI.Services
{
    /// <summary>
    /// Publishes reminder messages over a single lazily-created EasyNetQ bus
    /// (one AMQP connection for the process, not one per publish). Publish
    /// failures are retried with exponential backoff; the appointment booking
    /// itself must never fail because the broker is down, so the final
    /// failure is logged as an error and swallowed.
    /// </summary>
    public sealed class AppointmentReminderPublisher : IAppointmentReminderPublisher, IDisposable
    {
        private static readonly TimeSpan[] RetryDelays =
        {
            TimeSpan.FromMilliseconds(500),
            TimeSpan.FromSeconds(1),
            TimeSpan.FromSeconds(2),
        };

        private readonly ILogger<AppointmentReminderPublisher> _logger;
        private readonly Lazy<IBus> _bus;

        public AppointmentReminderPublisher(ILogger<AppointmentReminderPublisher> logger)
        {
            _logger = logger;
            var host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
            var username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
            var password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
            var virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";
            var connectionString = $"host={host};virtualHost={virtualHost};username={username};password={password}";
            _bus = new Lazy<IBus>(
                () => RabbitHutch.CreateBus(connectionString),
                LazyThreadSafetyMode.ExecutionAndPublication);
        }

        public async Task PublishAsync(
            AppointmentReminderMessage message,
            CancellationToken cancellationToken = default)
        {
            for (var attempt = 0; ; attempt++)
            {
                try
                {
                    await _bus.Value.PubSub.PublishAsync(message, cancellationToken);
                    _logger.LogInformation(
                        "Appointment reminder published for appointment {AppointmentId}",
                        message.AppointmentId);
                    return;
                }
                catch (Exception ex) when (attempt < RetryDelays.Length)
                {
                    _logger.LogWarning(
                        ex,
                        "Publish attempt {Attempt} failed for appointment {AppointmentId}; retrying in {Delay}",
                        attempt + 1,
                        message.AppointmentId,
                        RetryDelays[attempt]);
                    await Task.Delay(RetryDelays[attempt], cancellationToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError(
                        ex,
                        "Failed to publish appointment reminder for appointment {AppointmentId} after {Attempts} attempts",
                        message.AppointmentId,
                        RetryDelays.Length + 1);
                    return;
                }
            }
        }

        public void Dispose()
        {
            if (_bus.IsValueCreated)
            {
                _bus.Value.Dispose();
            }
        }
    }
}
