using SOH.Model.Requests;
using SOH.Model.Notifications;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using SOH.WebAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class AppointmentController : BaseCRUDController<AppointmentResponse, AppointmentSearchObject, AppointmentUpsertRequest, AppointmentUpsertRequest>
    {
        private readonly IAppointmentReminderPublisher _publisher;
        private readonly IAppointmentService _appointments;

        public AppointmentController(
            IAppointmentService service,
            IAppointmentReminderPublisher publisher) : base(service)
        {
            _publisher = publisher;
            _appointments = service;
        }

        // Patients see only their own visits. Doctors see appointments where
        // they are the assigned doctor. Admins see everything. We pin the
        // filter server-side so the IDs in JWT win over the query string.
        public override Task<PagedResult<AppointmentResponse>> Get([FromQuery] AppointmentSearchObject? search = null)
        {
            search ??= new AppointmentSearchObject();
            if (!CallerIsAdmin)
            {
                if (CallerIsDoctor)
                {
                    search.DoctorId = CallerUserId;
                }
                else
                {
                    search.PatientId = CallerUserId;
                }
            }
            return base.Get(search);
        }

        // Narrowing the list is not enough: a single appointment fetched by id
        // must belong to the caller as well, otherwise a guessed id exposes
        // another patient's visit.
        public override async Task<AppointmentResponse?> GetById(int id)
        {
            await EnsureCallerMayAccessAsync(_appointments, id);
            return await base.GetById(id);
        }

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override async Task<AppointmentResponse> Create([FromBody] AppointmentUpsertRequest request)
        {
            var created = await base.Create(request);

            if (created?.Id > 0)
            {
                await _publisher.PublishAsync(new AppointmentReminderMessage
                {
                    AppointmentId = created.Id,
                    PatientId = created.PatientId,
                    DoctorId = created.DoctorId,
                    ServiceId = created.ServiceId,
                    StartTimeUtc = created.StartTime.ToUniversalTime(),
                    ClientComplaint = request.DoctorNote
                });
            }

            return created;
        }

        // Status transitions and reschedules - admin or doctor only. A doctor
        // may only touch appointments assigned to them and cannot reassign
        // them to someone else. A patient cancels via the dedicated endpoint.
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override async Task<AppointmentResponse?> Update(int id, [FromBody] AppointmentUpsertRequest request)
        {
            if (!CallerIsAdmin)
            {
                await _appointments.EnsureDoctorOwnsAsync(id, CallerUserId);
                request.DoctorId = CallerUserId;
            }
            // The patient of an existing appointment is pinned server-side in
            // AppointmentService.BeforeUpdate, for the admin path too.
            return await base.Update(id, request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);

        // Dedicated cancel path so patients can cancel their own bookings
        // without the broad Update authorization. Ownership and the legal
        // status transition are enforced in the service.
        [HttpPost("{id:int}/cancel")]
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor + "," + RoleNames.Patient)]
        public async Task<ActionResult<AppointmentResponse>> Cancel(int id)
        {
            // A doctor is not simply "privileged": they may cancel the
            // appointments assigned to them, not a colleague's.
            var actor = CallerIsAdmin
                ? AppointmentActor.Administrator
                : CallerIsDoctor
                    ? AppointmentActor.Doctor
                    : AppointmentActor.Patient;
            var result = await _appointments.CancelOwnAsync(id, CallerUserId, actor);
            return Ok(result);
        }
    }
}
