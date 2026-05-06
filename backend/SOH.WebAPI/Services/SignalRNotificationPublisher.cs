using Microsoft.AspNetCore.SignalR;
using SOH.Services.Interfaces;
using SOH.WebAPI.Hubs;

namespace SOH.WebAPI.Services;

public class SignalRNotificationPublisher : INotificationRealtimePublisher
{
    private readonly IHubContext<NotificationHub> _hub;

    public SignalRNotificationPublisher(IHubContext<NotificationHub> hub)
    {
        _hub = hub;
    }

    public Task PushToUserAsync(int userId, int notificationId, string title, string body, CancellationToken cancellationToken = default)
    {
        return _hub.Clients.Group(HubGroups.User(userId.ToString())).SendAsync(
            "notification",
            new { id = notificationId, title, body },
            cancellationToken);
    }
}
