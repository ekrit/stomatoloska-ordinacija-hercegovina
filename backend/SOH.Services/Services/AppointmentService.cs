using Microsoft.EntityFrameworkCore;
using SOH.Model.Exceptions;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;
using AppointmentStatus = SOH.Services.Database.AppointmentStatus;

namespace SOH.Services.Services
{
    public class AppointmentService : BaseCRUDService<AppointmentResponse, AppointmentSearchObject, Appointment, AppointmentUpsertRequest, AppointmentUpsertRequest>, IAppointmentService
    {
        // Statuses that still consume the doctor's and room's time slot.
        // Declined and Cancelled free the slot for someone else.
        private static readonly AppointmentStatus[] BlockingStatuses =
        {
            AppointmentStatus.Requested,
            AppointmentStatus.Accepted,
            AppointmentStatus.Completed,
        };

        // Legal target statuses for each source status.
        // Declined / Completed / Cancelled are terminal.
        private static readonly Dictionary<AppointmentStatus, AppointmentStatus[]> AllowedTransitions = new()
        {
            [AppointmentStatus.Requested] = new[]
            {
                AppointmentStatus.Accepted,
                AppointmentStatus.Declined,
                AppointmentStatus.Cancelled,
            },
            [AppointmentStatus.Accepted] = new[]
            {
                AppointmentStatus.Completed,
                AppointmentStatus.Cancelled,
            },
            [AppointmentStatus.Declined] = Array.Empty<AppointmentStatus>(),
            [AppointmentStatus.Completed] = Array.Empty<AppointmentStatus>(),
            [AppointmentStatus.Cancelled] = Array.Empty<AppointmentStatus>(),
        };

        private readonly INotificationService _notifications;
        private readonly ICurrentUserAccessor _currentUser;

        public AppointmentService(
            SOHDbContext context,
            IMapper mapper,
            INotificationService notifications,
            ICurrentUserAccessor currentUser) : base(context, mapper)
        {
            _notifications = notifications;
            _currentUser = currentUser;
        }

        // Create/Update run two SaveChangesAsync calls (entity + audit log),
        // so both are wrapped in an explicit transaction.
        public override async Task<AppointmentResponse> CreateAsync(AppointmentUpsertRequest request)
        {
            await using var transaction = await _context.Database.BeginTransactionAsync();
            var result = await base.CreateAsync(request);
            await transaction.CommitAsync();
            return result;
        }

        public override async Task<AppointmentResponse?> UpdateAsync(int id, AppointmentUpsertRequest request)
        {
            await using var transaction = await _context.Database.BeginTransactionAsync();
            var result = await base.UpdateAsync(id, request);
            await transaction.CommitAsync();
            return result;
        }

        protected override async Task BeforeInsert(Appointment entity, AppointmentUpsertRequest request)
        {
            ValidateTimeRange(entity, isNew: true);

            // New appointments must always start in the future. Allowing past
            // requests lets a patient retroactively "book" a slot, which
            // breaks the doctor calendar and the reminder worker.
            if (entity.StartTime <= DateTime.UtcNow)
            {
                throw new BusinessException("Termin mora početi u budućnosti.");
            }

            // Force the initial status to Requested regardless of what the
            // client sent. Letting the client jump straight to Accepted /
            // Completed would bypass the doctor approval flow.
            entity.Status = AppointmentStatus.Requested;

            await EnsureNoConflictsAsync(entity, ignoreId: null);
        }

        protected override async Task BeforeUpdate(Appointment entity, AppointmentUpsertRequest request)
        {
            var newStatus = (AppointmentStatus)(int)request.Status;
            ValidateStatusTransition(entity.Status, newStatus);

            // A declined booking must carry the reason: the patient sees it in
            // the notification and the record keeps the audit trail complete.
            if (newStatus == AppointmentStatus.Declined &&
                entity.Status != AppointmentStatus.Declined &&
                string.IsNullOrWhiteSpace(request.DoctorNote))
            {
                throw new BusinessException("Razlog odbijanja termina je obavezan.");
            }

            // Only re-validate scheduling concerns when the appointment is
            // still active. Completing or cancelling does not need a clean
            // calendar (the slot might already be in the past).
            if (BlockingStatuses.Contains(newStatus))
            {
                // EF tracks `entity` so EndTime / StartTime already reflect
                // the in-flight request via Mapster mapping happening after
                // BeforeUpdate. We re-derive them from the request to make
                // sure the overlap check uses the values the caller asked
                // for, not the stale persisted ones.
                var prospective = new Appointment
                {
                    Id = entity.Id,
                    DoctorId = request.DoctorId,
                    RoomId = request.RoomId,
                    PatientId = entity.PatientId,
                    StartTime = request.StartTime,
                    EndTime = request.EndTime,
                };
                ValidateTimeRange(prospective, isNew: false);
                await EnsureNoConflictsAsync(prospective, ignoreId: entity.Id);
            }

            if (entity.Status != newStatus)
            {
                await _notifications.NotifyAppointmentStatusChangedAsync(
                    entity.PatientId,
                    entity.Id,
                    entity.Status,
                    newStatus,
                    newStatus == AppointmentStatus.Declined ? request.DoctorNote : null);
            }
        }

        public async Task EnsureDoctorOwnsAsync(int appointmentId, int doctorUserId, CancellationToken cancellationToken = default)
        {
            var doctorId = await _context.Appointments
                .AsNoTracking()
                .Where(a => a.Id == appointmentId)
                .Select(a => (int?)a.DoctorId)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new NotFoundException("Termin nije pronađen.");

            if (doctorId != doctorUserId)
            {
                throw new BusinessException("Možete uređivati samo termine koji su vam dodijeljeni.");
            }
        }

        private static void ValidateTimeRange(Appointment entity, bool isNew)
        {
            if (entity.EndTime <= entity.StartTime)
            {
                throw new BusinessException("Kraj termina mora biti nakon njegovog početka.");
            }
        }

        private static void ValidateStatusTransition(AppointmentStatus from, AppointmentStatus to)
        {
            if (from == to)
            {
                return;
            }

            if (!AllowedTransitions.TryGetValue(from, out var allowed) || Array.IndexOf(allowed, to) < 0)
            {
                throw new BusinessException(
                    $"Nedozvoljena promjena statusa termina: {from} -> {to}.");
            }
        }

        private async Task EnsureNoConflictsAsync(Appointment candidate, int? ignoreId)
        {
            // Overlap predicate: two ranges overlap when start1 < end2 and
            // start2 < end1. We also restrict the search to the relevant
            // day window to keep the query cheap on a growing table.
            var dayStart = candidate.StartTime.Date.AddDays(-1);
            var dayEnd = candidate.EndTime.Date.AddDays(1);

            var clash = await _context.Appointments.AsNoTracking()
                .Where(a => (ignoreId == null || a.Id != ignoreId.Value))
                .Where(a => BlockingStatuses.Contains(a.Status))
                .Where(a => a.StartTime < dayEnd && a.EndTime > dayStart)
                .Where(a => a.DoctorId == candidate.DoctorId
                    || a.RoomId == candidate.RoomId
                    || a.PatientId == candidate.PatientId)
                .Where(a => a.StartTime < candidate.EndTime && candidate.StartTime < a.EndTime)
                .Select(a => new { a.DoctorId, a.RoomId, a.PatientId })
                .FirstOrDefaultAsync();

            if (clash == null)
            {
                return;
            }

            if (clash.PatientId == candidate.PatientId)
            {
                throw new BusinessException(
                    "Već imate zakazan termin koji se preklapa s ovim vremenom.");
            }

            if (clash.DoctorId == candidate.DoctorId)
            {
                throw new BusinessException(
                    "Doktor već ima termin koji se preklapa s ovim vremenom.");
            }

            throw new BusinessException(
                "Prostorija je već zauzeta u ovom terminu.");
        }

        protected override async Task OnAfterInsertAsync(Appointment entity, AppointmentUpsertRequest request)
        {
            _context.ActivityLogs.Add(NewActivityLog("AppointmentCreated", entity.Id));
            await _context.SaveChangesAsync();
            await _notifications.NotifyAppointmentCreatedAsync(entity.PatientId, entity.Id);
        }

        protected override async Task OnAfterUpdateAsync(Appointment entity, AppointmentUpsertRequest request)
        {
            _context.ActivityLogs.Add(NewActivityLog("AppointmentUpdated", entity.Id));
            await _context.SaveChangesAsync();
        }

        private ActivityLog NewActivityLog(string action, int appointmentId)
        {
            return new ActivityLog
            {
                Action = action,
                EntityName = "Appointment",
                EntityId = appointmentId.ToString(),
                UserId = _currentUser.UserId,
                Username = _currentUser.Username,
                CreatedAt = DateTime.UtcNow
            };
        }

        public async Task<AppointmentResponse> CancelOwnAsync(int appointmentId, int callerUserId, bool isPrivileged, CancellationToken cancellationToken = default)
        {
            var entity = await _context.Appointments
                .Include(a => a.Payment)
                .FirstOrDefaultAsync(a => a.Id == appointmentId, cancellationToken)
                ?? throw new NotFoundException("Termin nije pronađen.");

            // Patients can only cancel their own bookings; the Patient PK is the
            // user id, so PatientId already equals the JWT user id.
            if (!isPrivileged && entity.PatientId != callerUserId)
            {
                throw new BusinessException("Možete otkazati samo vlastite termine.");
            }

            // Already cancelled is a no-op so a double tap does not error.
            if (entity.Status == AppointmentStatus.Cancelled)
            {
                return MapToResponse(entity);
            }

            // A paid appointment must go through the refund flow (which also
            // cancels it) so the payment and appointment never drift apart.
            if (entity.Payment != null && entity.Payment.Status == PaymentStatus.Paid)
            {
                throw new BusinessException("Ovaj termin je plaćen. Zatražite povrat novca da biste ga otkazali.");
            }

            var fromStatus = entity.Status;
            ValidateStatusTransition(fromStatus, AppointmentStatus.Cancelled);
            entity.Status = AppointmentStatus.Cancelled;

            _context.ActivityLogs.Add(NewActivityLog("AppointmentCancelled", entity.Id));

            await _context.SaveChangesAsync(cancellationToken);
            await _notifications.NotifyAppointmentStatusChangedAsync(
                entity.PatientId, entity.Id, fromStatus, AppointmentStatus.Cancelled, reason: null, cancellationToken);

            return MapToResponse(entity);
        }

        protected override AppointmentResponse MapToResponse(Appointment entity)
        {
            var response = base.MapToResponse(entity);
            if (entity.Payment != null)
            {
                response.PaymentId = entity.Payment.Id;
                response.IsPaid = entity.Payment.Status == PaymentStatus.Paid;
            }
            return response;
        }

        public override async Task<AppointmentResponse?> GetByIdAsync(int id)
        {
            var entity = await _context.Appointments
                .Include(a => a.Payment)
                .FirstOrDefaultAsync(a => a.Id == id);
            return entity == null ? null : MapToResponse(entity);
        }

        protected override IQueryable<Appointment> ApplyFilter(IQueryable<Appointment> query, AppointmentSearchObject search)
        {
            query = query.Include(x => x.Payment);

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

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Patient.FirstName.Contains(search.FTS) ||
                    x.Patient.LastName.Contains(search.FTS) ||
                    x.Doctor.FirstName.Contains(search.FTS) ||
                    x.Doctor.LastName.Contains(search.FTS) ||
                    x.Service.Name.Contains(search.FTS));
            }

            return query;
        }
    }
}
