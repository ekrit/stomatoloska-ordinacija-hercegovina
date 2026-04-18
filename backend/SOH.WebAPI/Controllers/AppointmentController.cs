using SOH.Model.Requests;
using SOH.Model.Notifications;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Services;
using Microsoft.AspNetCore.Mvc;

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
    }
}
