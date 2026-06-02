using SOH.Model.Requests;
using SOH.Model.Notifications;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using SOH.WebAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace SOH.WebAPI.Controllers
{
    public class AppointmentController : BaseCRUDController<AppointmentResponse, AppointmentSearchObject, AppointmentUpsertRequest, AppointmentUpsertRequest>
    {
        private readonly IAppointmentReminderPublisher _publisher;

        public AppointmentController(
            IAppointmentService service,
            IAppointmentReminderPublisher publisher) : base(service)
        {
            _publisher = publisher;
        }

        // Patients see only their own visits. Doctors see appointments where
        // they are the assigned doctor. Admins see everything. We pin the
        // filter server-side so the IDs in JWT win over the query string.
        public override Task<PagedResult<AppointmentResponse>> Get([FromQuery] AppointmentSearchObject? search = null)
        {
            search ??= new AppointmentSearchObject();
            if (!User.IsInRole(RoleNames.Administrator))
            {
                var uid = int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;
                if (User.IsInRole(RoleNames.Doctor))
                {
                    search.DoctorId = uid;
                }
                else
                {
                    search.PatientId = uid;
                }
            }
            return base.Get(search);
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

        // Status transitions and reschedules - admin or doctor only. A
        // patient cancels their booking via a dedicated endpoint elsewhere
        // (the mobile app posts Cancelled through Create-on-self), never
        // by mass-updating someone else's appointment.
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override Task<AppointmentResponse?> Update(int id, [FromBody] AppointmentUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
