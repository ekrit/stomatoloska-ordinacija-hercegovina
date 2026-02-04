using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class AppointmentService : BaseCRUDService<AppointmentResponse, AppointmentSearchObject, Appointment, AppointmentUpsertRequest, AppointmentUpsertRequest>, IAppointmentService
    {
        public AppointmentService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Appointment> ApplyFilter(IQueryable<Appointment> query, AppointmentSearchObject search)
        {
            if (search.PatientId.HasValue)
            {
                query = query.Where(x => x.PatientId == search.PatientId.Value);
            }

            if (search.DoctorId.HasValue)
            {
                query = query.Where(x => x.DoctorId == search.DoctorId.Value);
            }

            if (search.ServiceId.HasValue)
            {
                query = query.Where(x => x.ServiceId == search.ServiceId.Value);
            }

            if (search.RoomId.HasValue)
            {
                query = query.Where(x => x.RoomId == search.RoomId.Value);
            }

            if (search.Status.HasValue)
            {
                var status = (AppointmentStatus)(int)search.Status.Value;
                query = query.Where(x => x.Status == status);
            }

            if (search.StartFrom.HasValue)
            {
                query = query.Where(x => x.StartTime >= search.StartFrom.Value);
            }

            if (search.StartTo.HasValue)
            {
                query = query.Where(x => x.StartTime <= search.StartTo.Value);
            }

            return query;
        }
    }
}
