using Microsoft.EntityFrameworkCore;
using SOH.Model.Exceptions;
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
        private readonly ICurrentUserAccessor _currentUser;

        public MedicalRecordService(SOHDbContext context, IMapper mapper, ICurrentUserAccessor currentUser) : base(context, mapper)
        {
            _currentUser = currentUser;
        }

        // A finding may only be written by the doctor who performed the visit.
        // The controller allows the Doctor role as a whole, so without this a
        // doctor could file a diagnosis on a colleague's appointment.
        protected override async Task BeforeInsert(MedicalRecord entity, MedicalRecordUpsertRequest request)
        {
            await EnsureCallerMayWriteForAppointmentAsync(request.AppointmentId);
        }

        protected override async Task BeforeUpdate(MedicalRecord entity, MedicalRecordUpsertRequest request)
        {
            // The finding stays attached to the visit it documents. Moving it to
            // another appointment through an ordinary update would rewrite a
            // patient's medical history, so the id is pinned to the stored one.
            request.AppointmentId = entity.AppointmentId;

            await EnsureCallerMayWriteForAppointmentAsync(entity.AppointmentId);
        }

        private async Task EnsureCallerMayWriteForAppointmentAsync(int appointmentId)
        {
            var doctorId = await _context.Appointments
                .AsNoTracking()
                .Where(a => a.Id == appointmentId)
                .Select(a => (int?)a.DoctorId)
                .FirstOrDefaultAsync()
                ?? throw new NotFoundException("Termin nije pronađen.");

            if (_currentUser.IsDoctor && doctorId != _currentUser.UserId)
            {
                throw new ForbiddenException("Možete voditi nalaze samo za vlastite termine.");
            }
        }

        // A finding belongs to the patient and the doctor of its appointment.
        public async Task<RecordOwner?> GetOwnerAsync(int id, CancellationToken cancellationToken = default)
        {
            var owner = await _context.MedicalRecords
                .AsNoTracking()
                .Where(m => m.Id == id)
                .Select(m => new { m.Appointment.PatientId, m.Appointment.DoctorId })
                .FirstOrDefaultAsync(cancellationToken);

            return owner == null ? null : new RecordOwner(owner.PatientId, owner.DoctorId);
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
