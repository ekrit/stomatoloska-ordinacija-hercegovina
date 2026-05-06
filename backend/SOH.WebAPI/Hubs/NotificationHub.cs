using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace SOH.WebAPI.Hubs;

[Authorize]
public class NotificationHub : Hub
{
    public override async Task OnConnectedAsync()
    {
        var id = Context.User?.FindFirstValue(ClaimTypes.NameIdentifier);
        if (!string.IsNullOrEmpty(id))
            await Groups.AddToGroupAsync(Context.ConnectionId, HubGroups.User(id));
        await base.OnConnectedAsync();
    }

    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        var id = Context.User?.FindFirstValue(ClaimTypes.NameIdentifier);
        if (!string.IsNullOrEmpty(id))
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, HubGroups.User(id));
        await base.OnDisconnectedAsync(exception);
    }
}

public static class HubGroups
{
    public static string User(string userId) => $"user-{userId}";
}
