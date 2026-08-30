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
            // A patient books for themselves and nobody else. The PatientId in
            // the request is client input, so it is replaced with the identity
            // from the JWT rather than validated against it — a direct API call
            // cannot book in another patient's name. Only an administrator,
            // who books on behalf of patients at the desk, keeps the sent id.
            if (_currentUser.IsPatient && _currentUser.UserId is int callerId)
            {
                entity.PatientId = callerId;
            }

            // The visit's length is a property of the service, not something
            // the client gets to declare. A client-supplied EndTime could book
            // a 60-minute treatment into a 30-minute hole.
            var durationMinutes = await _context.Services
                .AsNoTracking()
                .Where(s => s.Id == entity.ServiceId)
                .Select(s => (int?)s.DurationMinutes)
                .FirstOrDefaultAsync()
                ?? throw new NotFoundException("Usluga nije pronađena.");

            if (durationMinutes <= 0)
            {
                throw new BusinessException("Usluga nema definisano trajanje; termin se ne može zakazati.");
            }

            entity.EndTime = entity.StartTime.AddMinutes(durationMinutes);

            ValidateTimeRange(entity, isNew: true);

            // New appointments must always start in the future. Allowing past
            // requests lets a patient retroactively "book" a slot, which
            // breaks the doctor calendar and the reminder worker.
            if (entity.StartTime <= DateTime.UtcNow)
            {
                throw new BusinessException("Termin mora početi u budućnosti.");
            }

            // Working hours are enforced here, not only in the client, so a
            // direct API call cannot book outside them.
            if (!ClinicSchedule.IsWithinWorkingHours(entity.StartTime, entity.EndTime))
            {
                throw new BusinessException(
                    $"Termin mora biti unutar radnog vremena ({ClinicSchedule.WorkdayStartHour:00}-{ClinicSchedule.WorkdayEndHour:00}) i završiti istog dana.");
            }

            entity.RoomId = await ResolveRoomAsync(entity.RoomId, entity.StartTime, entity.EndTime, ignoreId: null);

            // Booking notes are the patient's complaint, and nothing else: the
            // doctor's note and the rejection reason have their own fields.
            entity.PatientComplaint = string.IsNullOrWhiteSpace(request.PatientComplaint)
                ? null
                : request.PatientComplaint.Trim();
            entity.DoctorNote = null;
            entity.DeclineReason = null;
            entity.CancelReason = null;

            // Force the initial status to Requested regardless of what the
            // client sent. Letting the client jump straight to Accepted /
            // Completed would bypass the doctor approval flow.
            entity.Status = AppointmentStatus.Requested;

            await EnsureNoConflictsAsync(entity, ignoreId: null);
        }

        /// <summary>
        /// Validates the requested room, or picks one when the caller did not
        /// name a usable one. The client used to choose the room itself and
        /// fall back to <c>rooms.first</c> when none were available, while the
        /// server checked neither <see cref="Room.IsAvailable"/> nor whether
        /// the room was free.
        /// </summary>
        private async Task<int> ResolveRoomAsync(int requestedRoomId, DateTime start, DateTime end, int? ignoreId)
        {
            if (requestedRoomId > 0)
            {
                var room = await _context.Rooms
                    .AsNoTracking()
                    .FirstOrDefaultAsync(r => r.Id == requestedRoomId)
                    ?? throw new NotFoundException("Prostorija nije pronađena.");

                if (!room.IsAvailable)
                {
                    throw new BusinessException("Odabrana prostorija nije u upotrebi.");
                }

                if (await IsRoomBusyAsync(room.Id, start, end, ignoreId))
                {
                    throw new BusinessException("Prostorija je već zauzeta u ovom terminu.");
                }

                return room.Id;
            }

            var freeRoomId = await FindFreeRoomIdAsync(start, end, ignoreId);
            return freeRoomId
                ?? throw new BusinessException("Nema slobodne prostorije u odabranom terminu.");
        }

        private Task<bool> IsRoomBusyAsync(int roomId, DateTime start, DateTime end, int? ignoreId)
        {
            return _context.Appointments
                .AsNoTracking()
                .Where(a => ignoreId == null || a.Id != ignoreId.Value)
                .Where(a => a.RoomId == roomId)
                .Where(a => BlockingStatuses.Contains(a.Status))
                .AnyAsync(a => a.StartTime < end && start < a.EndTime);
        }

        private async Task<int?> FindFreeRoomIdAsync(DateTime start, DateTime end, int? ignoreId)
        {
            var usableRoomIds = await _context.Rooms
                .AsNoTracking()
                .Where(r => r.IsAvailable)
                .OrderBy(r => r.Id)
                .Select(r => r.Id)
                .ToListAsync();

            if (usableRoomIds.Count == 0)
            {
                return null;
            }

            var takenRoomIds = await _context.Appointments
                .AsNoTracking()
                .Where(a => ignoreId == null || a.Id != ignoreId.Value)
                .Where(a => BlockingStatuses.Contains(a.Status))
                .Where(a => a.StartTime < end && start < a.EndTime)
                .Select(a => a.RoomId)
                .ToListAsync();

            return usableRoomIds.FirstOrDefault(id => !takenRoomIds.Contains(id)) is var found && found != 0
                ? found
                : null;
        }

        protected override async Task BeforeUpdate(Appointment entity, AppointmentUpsertRequest request)
        {
            // The appointment stays pinned to the patient who booked it. The
            // request still carries a PatientId (it shares the insert model),
            // and Mapster would otherwise write it straight onto the entity,
            // letting an update move someone else's visit onto this slot.
            request.PatientId = entity.PatientId;

            // Once money has been taken, the commercially meaningful fields are
            // frozen. Otherwise the service or the slot could be swapped after
            // payment and the captured amount would silently belong to a
            // different (possibly more expensive) treatment. Status changes and
            // notes stay open; changing the service or time needs a refund and
            // a new booking.
            var isPaid = await _context.Payments
                .AsNoTracking()
                .AnyAsync(p => p.AppointmentId == entity.Id && p.Status == PaymentStatus.Paid);

            if (isPaid)
            {
                if (request.ServiceId != entity.ServiceId ||
                    request.StartTime != entity.StartTime ||
                    request.EndTime != entity.EndTime)
                {
                    throw new BusinessException(
                        "Termin je plaćen; usluga i vrijeme se ne mogu mijenjati. Zatražite povrat novca i zakažite ponovo.");
                }

                request.ServiceId = entity.ServiceId;
                request.StartTime = entity.StartTime;
                request.EndTime = entity.EndTime;
            }

            var newStatus = (AppointmentStatus)(int)request.Status;
            ValidateStatusTransition(entity.Status, newStatus);

            // A declined booking must carry its own reason. This used to accept
            // DoctorNote, which booking had already filled with the service name
            // and the patient's complaint — so the check passed without the
            // doctor ever giving a reason.
            if (newStatus == AppointmentStatus.Declined &&
                entity.Status != AppointmentStatus.Declined)
            {
                if (string.IsNullOrWhiteSpace(request.DeclineReason))
                {
                    throw new BusinessException("Razlog odbijanja termina je obavezan.");
                }

                entity.DeclineReason = request.DeclineReason!.Trim();
            }

            // A visit cannot be completed before it has happened. Completing
            // early makes everything gated on a finished appointment — a review,
            // most obviously — available too soon.
            if (newStatus == AppointmentStatus.Completed &&
                entity.Status != AppointmentStatus.Completed &&
                DateTime.UtcNow < entity.EndTime)
            {
                throw new BusinessException("Termin se može označiti završenim tek nakon njegovog kraja.");
            }

            // The patient's complaint belongs to the patient; a doctor editing
            // the appointment must not overwrite it.
            request.PatientComplaint = entity.PatientComplaint;

            // Only re-validate scheduling concerns when the appointment is
            // still active. Completing or cancelling does not need a clean
            // calendar (the slot might already be in the past).
            if (BlockingStatuses.Contains(newStatus))
            {
                // A reschedule is governed by the same server-side rules as a
                // new booking: the visit length is derived from the service
                // (never trusted from the client's EndTime) and the range must
                // fall inside working hours. Applying this only on insert left
                // the update path able to accept an arbitrary EndTime and to
                // move a visit outside 08-18 — the exact defect the original
                // review raised, still live on reschedules. Paid appointments
                // already have service/time pinned above, so only an unpaid
                // reschedule recomputes them.
                var scheduleChanged = !isPaid &&
                    (request.ServiceId != entity.ServiceId || request.StartTime != entity.StartTime);

                if (scheduleChanged)
                {
                    var durationMinutes = await _context.Services
                        .AsNoTracking()
                        .Where(s => s.Id == request.ServiceId)
                        .Select(s => (int?)s.DurationMinutes)
                        .FirstOrDefaultAsync()
                        ?? throw new NotFoundException("Usluga nije pronađena.");

                    if (durationMinutes <= 0)
                    {
                        throw new BusinessException("Usluga nema definisano trajanje; termin se ne može zakazati.");
                    }

                    request.EndTime = request.StartTime.AddMinutes(durationMinutes);

                    if (!ClinicSchedule.IsWithinWorkingHours(request.StartTime, request.EndTime))
                    {
                        throw new BusinessException(
                            $"Termin mora biti unutar radnog vremena ({ClinicSchedule.WorkdayStartHour:00}-{ClinicSchedule.WorkdayEndHour:00}) i završiti istog dana.");
                    }
                }
                else
                {
                    // A status-only change (accept, complete) does not let the
                    // client move the schedule: pin service and both times to
                    // the stored values so a stray EndTime in the body is
                    // ignored.
                    request.ServiceId = entity.ServiceId;
                    request.StartTime = entity.StartTime;
                    request.EndTime = entity.EndTime;
                }

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
                var reason = newStatus == AppointmentStatus.Declined
                    ? entity.DeclineReason
                    : null;

                RecordStatusChange(entity.Id, entity.Status, newStatus, reason);

                await _notifications.NotifyAppointmentStatusChangedAsync(
                    entity.PatientId,
                    entity.Id,
                    entity.Status,
                    newStatus,
                    reason);
            }
        }

        /// <summary>
        /// Real bookable slots for a doctor, day and service.
        /// <para>
        /// The client used to build this itself from the appointment list, but
        /// that list is patient-scoped: a patient never saw other patients'
        /// bookings, so slots already taken looked free. It also assumed a flat
        /// 30 minutes before the service was even chosen, picked the room on
        /// its own, and knew the working hours only from its own config. All of
        /// that is decided here now, and <c>BeforeInsert</c> re-checks the same
        /// rules when the booking actually arrives.
        /// </para>
        /// </summary>
        public async Task<IReadOnlyList<AvailabilitySlotResponse>> GetAvailabilityAsync(
            int doctorId,
            DateTime date,
            int serviceId,
            CancellationToken cancellationToken = default)
        {
            var duration = await _context.Services
                .AsNoTracking()
                .Where(s => s.Id == serviceId)
                .Select(s => (int?)s.DurationMinutes)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new NotFoundException("Usluga nije pronađena.");

            if (duration <= 0)
            {
                throw new BusinessException("Usluga nema definisano trajanje.");
            }

            if (!await _context.Doctors.AsNoTracking().AnyAsync(d => d.UserId == doctorId, cancellationToken))
            {
                throw new NotFoundException("Doktor nije pronađen.");
            }

            var day = date.Date;
            var dayStart = day.AddHours(ClinicSchedule.WorkdayStartHour);
            var dayEnd = day.AddHours(ClinicSchedule.WorkdayEndHour);

            var usableRooms = await _context.Rooms
                .AsNoTracking()
                .Where(r => r.IsAvailable)
                .OrderBy(r => r.Id)
                .Select(r => new { r.Id, r.Name })
                .ToListAsync(cancellationToken);

            if (usableRooms.Count == 0)
            {
                return Array.Empty<AvailabilitySlotResponse>();
            }

            // Every booking that still holds time that day — for this doctor
            // (whoever the patient is) and for the rooms.
            var busy = await _context.Appointments
                .AsNoTracking()
                .Where(a => BlockingStatuses.Contains(a.Status))
                .Where(a => a.StartTime < dayEnd && a.EndTime > dayStart)
                .Select(a => new { a.DoctorId, a.RoomId, a.StartTime, a.EndTime })
                .ToListAsync(cancellationToken);

            var now = DateTime.UtcNow;
            var slots = new List<AvailabilitySlotResponse>();

            for (var start = dayStart; start.AddMinutes(duration) <= dayEnd; start = start.AddMinutes(ClinicSchedule.SlotStepMinutes))
            {
                var end = start.AddMinutes(duration);
                if (start <= now)
                {
                    continue;
                }

                var doctorBusy = busy.Any(b =>
                    b.DoctorId == doctorId && b.StartTime < end && start < b.EndTime);
                if (doctorBusy)
                {
                    continue;
                }

                var room = usableRooms.FirstOrDefault(r =>
                    !busy.Any(b => b.RoomId == r.Id && b.StartTime < end && start < b.EndTime));
                if (room == null)
                {
                    continue;
                }

                slots.Add(new AvailabilitySlotResponse
                {
                    StartTime = start,
                    EndTime = end,
                    RoomId = room.Id,
                    RoomName = room.Name,
                });
            }

            return slots;
        }

        public async Task<RecordOwner?> GetOwnerAsync(int id, CancellationToken cancellationToken = default)
        {
            var owner = await _context.Appointments
                .AsNoTracking()
                .Where(a => a.Id == id)
                .Select(a => new { a.PatientId, a.DoctorId })
                .FirstOrDefaultAsync(cancellationToken);

            return owner == null ? null : new RecordOwner(owner.PatientId, owner.DoctorId);
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
                throw new ForbiddenException("Možete uređivati samo termine koji su vam dodijeljeni.");
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

        /// <summary>
        /// Appends the who / when / from → to / why row for a status change.
        /// Saved by the caller's SaveChanges, inside the same transaction as
        /// the change itself.
        /// </summary>
        private void RecordStatusChange(int appointmentId, AppointmentStatus from, AppointmentStatus to, string? reason)
        {
            _context.AppointmentStatusHistories.Add(new AppointmentStatusHistory
            {
                AppointmentId = appointmentId,
                FromStatus = from,
                ToStatus = to,
                Reason = string.IsNullOrWhiteSpace(reason) ? null : reason.Trim(),
                ChangedByUserId = _currentUser.UserId,
                ChangedByUsername = _currentUser.Username,
                ChangedAt = DateTime.UtcNow,
            });
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

        public async Task<AppointmentResponse> CancelOwnAsync(int appointmentId, int callerUserId, AppointmentActor actor, string reason, CancellationToken cancellationToken = default)
        {
            var entity = await _context.Appointments
                .Include(a => a.Payment)
                .FirstOrDefaultAsync(a => a.Id == appointmentId, cancellationToken)
                ?? throw new NotFoundException("Termin nije pronađen.");

            // Each role is bound to the appointments it owns. Patient and Doctor
            // primary keys are both the user id, so the JWT id compares directly.
            // Only an administrator may cancel an appointment that is not theirs.
            switch (actor)
            {
                case AppointmentActor.Administrator:
                    break;

                case AppointmentActor.Doctor when entity.DoctorId != callerUserId:
                    throw new ForbiddenException("Možete otkazati samo termine koji su vam dodijeljeni.");

                case AppointmentActor.Patient when entity.PatientId != callerUserId:
                    throw new ForbiddenException("Možete otkazati samo vlastite termine.");
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

            if (string.IsNullOrWhiteSpace(reason))
            {
                throw new BusinessException("Razlog otkazivanja termina je obavezan.");
            }

            var trimmedReason = reason.Trim();
            var fromStatus = entity.Status;
            ValidateStatusTransition(fromStatus, AppointmentStatus.Cancelled);
            entity.Status = AppointmentStatus.Cancelled;
            entity.CancelReason = trimmedReason;

            _context.ActivityLogs.Add(NewActivityLog("AppointmentCancelled", entity.Id));
            RecordStatusChange(entity.Id, fromStatus, AppointmentStatus.Cancelled, trimmedReason);

            await _context.SaveChangesAsync(cancellationToken);
            await _notifications.NotifyAppointmentStatusChangedAsync(
                entity.PatientId, entity.Id, fromStatus, AppointmentStatus.Cancelled, trimmedReason, cancellationToken);

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
