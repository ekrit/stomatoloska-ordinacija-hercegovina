using SOH.Model.Responses;
using SOH.Services.Database;

namespace SOH.Services.Interfaces;

public interface INotificationService
{
    Task<IReadOnlyList<UserNotificationResponse>> ListForUserAsync(int userId, int take, CancellationToken cancellationToken = default);

    Task<int> GetUnreadCountAsync(int userId, CancellationToken cancellationToken = default);

    Task<bool> MarkReadAsync(int userId, int notificationId, CancellationToken cancellationToken = default);

    Task NotifyAppointmentCreatedAsync(int patientUserId, int appointmentId, CancellationToken cancellationToken = default);

    Task NotifyAppointmentStatusChangedAsync(
        int patientUserId,
        int appointmentId,
        AppointmentStatus fromStatus,
        AppointmentStatus toStatus,
        CancellationToken cancellationToken = default);
}
