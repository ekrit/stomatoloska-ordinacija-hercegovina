using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class MedicalRecordService : BaseCRUDService<MedicalRecordResponse, MedicalRecordSearchObject, MedicalRecord, MedicalRecordUpsertRequest, MedicalRecordUpsertRequest>, IMedicalRecordService
    {
        public MedicalRecordService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<MedicalRecord> ApplyFilter(IQueryable<MedicalRecord> query, MedicalRecordSearchObject search)
        {
            if (search.AppointmentId.HasValue)
            {
                query = query.Where(x => x.AppointmentId == search.AppointmentId.Value);
            }

            if (search.PatientId.HasValue)
            {
                query = query.Where(x => x.Appointment.PatientId == search.PatientId.Value);
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Diagnosis.Contains(search.FTS) ||
                    x.Treatment.Contains(search.FTS) ||
                    x.Appointment.Patient.FirstName.Contains(search.FTS) ||
                    x.Appointment.Patient.LastName.Contains(search.FTS));
            }

            return query.OrderByDescending(x => x.CreatedAt);
        }
    }
}
