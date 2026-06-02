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

        public AppointmentService(SOHDbContext context, IMapper mapper, INotificationService notifications) : base(context, mapper)
        {
            _notifications = notifications;
        }

        protected override async Task BeforeInsert(Appointment entity, AppointmentUpsertRequest request)
        {
            ValidateTimeRange(entity, isNew: true);

            // New appointments must always start in the future. Allowing past
            // requests lets a patient retroactively "book" a slot, which
            // breaks the doctor calendar and the reminder worker.
            if (entity.StartTime <= DateTime.UtcNow)
            {
                throw new BusinessException("Appointments must start in the future.");
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
                    newStatus);
            }
        }

        private static void ValidateTimeRange(Appointment entity, bool isNew)
        {
            if (entity.EndTime <= entity.StartTime)
            {
                throw new BusinessException("Appointment end time must be after start time.");
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
                    $"Illegal appointment status transition: {from} -> {to}.");
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
                .Where(a => a.DoctorId == candidate.DoctorId || a.RoomId == candidate.RoomId)
                .Where(a => a.StartTime < candidate.EndTime && candidate.StartTime < a.EndTime)
                .Select(a => new { a.DoctorId, a.RoomId })
                .FirstOrDefaultAsync();

            if (clash == null)
            {
                return;
            }

            if (clash.DoctorId == candidate.DoctorId)
            {
                throw new BusinessException(
                    "Doctor already has an appointment that overlaps this time range.");
            }

            throw new BusinessException(
                "Room is already booked for an appointment that overlaps this time range.");
        }

        protected override async Task OnAfterInsertAsync(Appointment entity, AppointmentUpsertRequest request)
        {
            _context.ActivityLogs.Add(new ActivityLog
            {
                Action = "AppointmentCreated",
                EntityName = "Appointment",
                EntityId = entity.Id.ToString(),
                CreatedAt = DateTime.UtcNow
            });
            await _context.SaveChangesAsync();
            await _notifications.NotifyAppointmentCreatedAsync(entity.PatientId, entity.Id);
        }

        protected override async Task OnAfterUpdateAsync(Appointment entity, AppointmentUpsertRequest request)
        {
            _context.ActivityLogs.Add(new ActivityLog
            {
                Action = "AppointmentUpdated",
                EntityName = "Appointment",
                EntityId = entity.Id.ToString(),
                CreatedAt = DateTime.UtcNow
            });
            await _context.SaveChangesAsync();
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

            return query;
        }
    }
}
