using Microsoft.EntityFrameworkCore;
using SOH.Model.Responses;
using SOH.Services.Database;
using SOH.Services.Interfaces;

namespace SOH.Services.Services;

public class NotificationService : INotificationService
{
    private readonly SOHDbContext _context;
    private readonly INotificationRealtimePublisher _realtime;

    public NotificationService(SOHDbContext context, INotificationRealtimePublisher realtime)
    {
        _context = context;
        _realtime = realtime;
    }

    public async Task<IReadOnlyList<UserNotificationResponse>> ListForUserAsync(int userId, int take, CancellationToken cancellationToken = default)
    {
        take = Math.Clamp(take, 1, 100);
        return await _context.UserNotifications
            .AsNoTracking()
            .Where(n => n.UserId == userId)
            .OrderByDescending(n => n.CreatedAt)
            .Take(take)
            .Select(n => new UserNotificationResponse
            {
                Id = n.Id,
                Title = n.Title,
                Body = n.Body,
                CreatedAt = n.CreatedAt,
                ReadAt = n.ReadAt,
                IsRead = n.ReadAt != null
            })
            .ToListAsync(cancellationToken);
    }

    public async Task<int> GetUnreadCountAsync(int userId, CancellationToken cancellationToken = default)
    {
        return await _context.UserNotifications
            .CountAsync(n => n.UserId == userId && n.ReadAt == null, cancellationToken);
    }

    public async Task<bool> MarkReadAsync(int userId, int notificationId, CancellationToken cancellationToken = default)
    {
        var n = await _context.UserNotifications
            .FirstOrDefaultAsync(x => x.Id == notificationId && x.UserId == userId, cancellationToken);
        if (n == null)
            return false;
        n.ReadAt = DateTime.UtcNow;
        await _context.SaveChangesAsync(cancellationToken);
        return true;
    }

    public async Task NotifyAppointmentCreatedAsync(int patientUserId, int appointmentId, CancellationToken cancellationToken = default)
    {
        var title = "Appointment scheduled";
        var body = $"Your appointment #{appointmentId} has been recorded. You will receive updates when its status changes.";
        await AddAndPushAsync(patientUserId, title, body, cancellationToken);
    }

    public async Task NotifyAppointmentStatusChangedAsync(
        int patientUserId,
        int appointmentId,
        AppointmentStatus fromStatus,
        AppointmentStatus toStatus,
        CancellationToken cancellationToken = default)
    {
        var title = "Appointment status updated";
        var body = $"Appointment #{appointmentId} moved from {fromStatus} to {toStatus}.";
        await AddAndPushAsync(patientUserId, title, body, cancellationToken);
    }

    private async Task AddAndPushAsync(int userId, string title, string body, CancellationToken cancellationToken)
    {
        var entity = new UserNotification
        {
            UserId = userId,
            Title = title,
            Body = body,
            CreatedAt = DateTime.UtcNow
        };
        _context.UserNotifications.Add(entity);
        await _context.SaveChangesAsync(cancellationToken);
        await _realtime.PushToUserAsync(userId, entity.Id, title, body, cancellationToken);
    }
}
