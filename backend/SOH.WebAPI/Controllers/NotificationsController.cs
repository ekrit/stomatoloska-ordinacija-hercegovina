using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Responses;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers;

[ApiController]
[Route("notifications")]
[Authorize]
public class NotificationsController : ControllerBase
{
    private readonly INotificationService _notifications;

    public NotificationsController(INotificationService notifications)
    {
        _notifications = notifications;
    }

    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<UserNotificationResponse>>> List([FromQuery] int take = 30)
    {
        var uid = CurrentUserId();
        if (uid == null)
            return Unauthorized();
        return Ok(await _notifications.ListForUserAsync(uid.Value, take));
    }

    [HttpGet("unread-count")]
    public async Task<ActionResult<int>> UnreadCount()
    {
        var uid = CurrentUserId();
        if (uid == null)
            return Unauthorized();
        return Ok(await _notifications.GetUnreadCountAsync(uid.Value));
    }

    [HttpPatch("{id:int}/read")]
    public async Task<ActionResult> MarkRead(int id)
    {
        var uid = CurrentUserId();
        if (uid == null)
            return Unauthorized();
        var ok = await _notifications.MarkReadAsync(uid.Value, id);
        return ok ? NoContent() : NotFound();
    }

    private int? CurrentUserId()
    {
        var v = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(v, out var id) ? id : null;
    }
}
