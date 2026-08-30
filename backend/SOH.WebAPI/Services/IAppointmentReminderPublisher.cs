using SOH.Model.Notifications;

namespace SOH.WebAPI.Services
{
    public interface IAppointmentReminderPublisher
    {
        Task PublishAsync(AppointmentReminderMessage message, CancellationToken cancellationToken = default);
    }
}

namespace SOH.WebAPI.Services
{
    /// <summary>
    /// Publishes password-reset codes to the notification worker, which mails
    /// them out. Kept separate from the reminder interface so callers depend
    /// only on what they use; the same bus connection serves both.
    /// </summary>
    public interface IPasswordResetPublisher
    {
        Task PublishAsync(SOH.Model.Notifications.PasswordResetRequestedMessage message, CancellationToken cancellationToken = default);
    }
}
