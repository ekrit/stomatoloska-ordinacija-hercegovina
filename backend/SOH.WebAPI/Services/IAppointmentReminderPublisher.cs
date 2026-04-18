using SOH.Model.Notifications;

namespace SOH.WebAPI.Services
{
    public interface IAppointmentReminderPublisher
    {
        Task PublishAsync(AppointmentReminderMessage message, CancellationToken cancellationToken = default);
    }
}
