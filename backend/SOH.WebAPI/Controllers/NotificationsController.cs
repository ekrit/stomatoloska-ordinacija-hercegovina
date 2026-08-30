using System.IdentityModel.Tokens.Jwt;
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

    /// <summary>
    /// Marks one notification as read.
    /// <para>
    /// Exposed only as a write. This used to answer on GET as well, but GET is
    /// defined as safe: intermediaries may cache it and clients, crawlers and
    /// link prefetchers may issue it on their own, which would silently flip
    /// read state. PUT is dropped too — the request does not carry a full
    /// representation of the resource — leaving POST and PATCH.
    /// </para>
    /// </summary>
    [HttpPost("{id:int}/read")]
    [HttpPatch("{id:int}/read")]
    public async Task<ActionResult> MarkRead(int id)
    {
        var uid = CurrentUserId();
        if (uid == null)
            return Unauthorized();
        Response.Headers.CacheControl = "no-store, no-cache, must-revalidate";
        Response.Headers.Pragma = "no-cache";
        var ok = await _notifications.MarkReadAsync(uid.Value, id);
        return ok ? NoContent() : NotFound();
    }

    private int? CurrentUserId()
    {
        var v = User.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? User.FindFirstValue(JwtRegisteredClaimNames.Sub);
        return int.TryParse(v, out var id) ? id : null;
    }
}
