using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IAppointmentService : ICRUDService<AppointmentResponse, AppointmentSearchObject, AppointmentUpsertRequest, AppointmentUpsertRequest>, IRecordOwnership
    {
        /// <summary>
        /// Cancels an appointment on behalf of the current user. A patient may
        /// only cancel their own bookings and a doctor only the appointments
        /// assigned to them; an administrator may cancel any. The status
        /// transition, notification, and audit trail go through the centralized
        /// state machine.
        /// </summary>
        Task<AppointmentResponse> CancelOwnAsync(int appointmentId, int callerUserId, AppointmentActor actor, string reason, CancellationToken cancellationToken = default);

        /// <summary>
        /// Throws unless the appointment is assigned to the given doctor.
        /// Used to stop a doctor from updating another doctor's appointment.
        /// </summary>
        Task EnsureDoctorOwnsAsync(int appointmentId, int doctorUserId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Slots that are genuinely bookable for a doctor, day and service:
        /// the service's real duration, a free doctor, a free usable room and
        /// the clinic's working hours, all decided server-side.
        /// </summary>
        Task<IReadOnlyList<AvailabilitySlotResponse>> GetAvailabilityAsync(int doctorId, DateTime date, int serviceId, CancellationToken cancellationToken = default);
    }
}
