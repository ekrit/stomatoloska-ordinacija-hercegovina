using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IAppointmentService : ICRUDService<AppointmentResponse, AppointmentSearchObject, AppointmentUpsertRequest, AppointmentUpsertRequest>
    {
        /// <summary>
        /// Cancels an appointment on behalf of the current user. Patients may
        /// only cancel their own bookings; admins and doctors (privileged) may
        /// cancel any. The status transition, notification, and audit trail go
        /// through the centralized state machine.
        /// </summary>
        Task<AppointmentResponse> CancelOwnAsync(int appointmentId, int callerUserId, bool isPrivileged, CancellationToken cancellationToken = default);

        /// <summary>
        /// Throws unless the appointment is assigned to the given doctor.
        /// Used to stop a doctor from updating another doctor's appointment.
        /// </summary>
        Task EnsureDoctorOwnsAsync(int appointmentId, int doctorUserId, CancellationToken cancellationToken = default);
    }
}
