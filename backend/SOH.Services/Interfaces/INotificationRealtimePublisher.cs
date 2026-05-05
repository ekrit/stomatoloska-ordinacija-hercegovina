namespace SOH.Services.Interfaces;

public interface INotificationRealtimePublisher
{
    Task PushToUserAsync(int userId, int notificationId, string title, string body, CancellationToken cancellationToken = default);
}
