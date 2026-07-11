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
    public class ReviewService : BaseCRUDService<ReviewResponse, ReviewSearchObject, Review, ReviewUpsertRequest, ReviewUpsertRequest>, IReviewService
    {
        private readonly ICurrentUserAccessor _currentUser;

        public ReviewService(SOHDbContext context, IMapper mapper, ICurrentUserAccessor currentUser) : base(context, mapper)
        {
            _currentUser = currentUser;
        }

        protected override IQueryable<Review> ApplyFilter(IQueryable<Review> query, ReviewSearchObject search)
        {
            if (search.AppointmentId.HasValue)
            {
                query = query.Where(x => x.AppointmentId == search.AppointmentId.Value);
            }

            if (search.PatientId.HasValue)
            {
                query = query.Where(x => x.PatientId == search.PatientId.Value);
            }

            if (search.DoctorId.HasValue)
            {
                query = query.Where(x => x.DoctorId == search.DoctorId.Value);
            }

            if (search.Rating.HasValue)
            {
                query = query.Where(x => x.Rating == search.Rating.Value);
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    (x.Comment != null && x.Comment.Contains(search.FTS)) ||
                    x.Patient.FirstName.Contains(search.FTS) ||
                    x.Patient.LastName.Contains(search.FTS) ||
                    x.Doctor.FirstName.Contains(search.FTS) ||
                    x.Doctor.LastName.Contains(search.FTS));
            }

            return query.OrderByDescending(x => x.CreatedAt);
        }

        // A review is only valid for a completed appointment that belongs to
        // the calling patient, and each appointment can be reviewed once.
        // Patient and doctor ids always come from the appointment + JWT, never
        // from the request body.
        protected override async Task BeforeInsert(Review entity, ReviewUpsertRequest request)
        {
            var appointment = await _context.Appointments
                .AsNoTracking()
                .FirstOrDefaultAsync(a => a.Id == request.AppointmentId)
                ?? throw new NotFoundException("Termin nije pronađen.");

            var callerId = _currentUser.UserId;
            if (callerId.HasValue && appointment.PatientId != callerId.Value)
            {
                throw new BusinessException("Možete ocijeniti samo vlastite termine.");
            }

            if (appointment.Status != AppointmentStatus.Completed)
            {
                throw new BusinessException("Termin se može ocijeniti tek nakon što je završen.");
            }

            if (await _context.Reviews.AnyAsync(r => r.AppointmentId == request.AppointmentId))
            {
                throw new BusinessException("Ovaj termin je već ocijenjen.");
            }

            ValidateRating(request.Rating);

            entity.PatientId = appointment.PatientId;
            entity.DoctorId = appointment.DoctorId;
            entity.CreatedAt = DateTime.UtcNow;
        }

        protected override async Task BeforeUpdate(Review entity, ReviewUpsertRequest request)
        {
            var callerId = _currentUser.UserId;
            if (callerId.HasValue && entity.PatientId != callerId.Value &&
                !await CallerIsAdminAsync(callerId.Value))
            {
                throw new BusinessException("Možete uređivati samo vlastite recenzije.");
            }

            ValidateRating(request.Rating);

            // The review stays pinned to its original appointment and parties.
            request.AppointmentId = entity.AppointmentId;
            request.PatientId = entity.PatientId;
            request.DoctorId = entity.DoctorId;
        }

        private static void ValidateRating(int rating)
        {
            if (rating < 1 || rating > 5)
            {
                throw new BusinessException("Ocjena mora biti između 1 i 5 zvjezdica.");
            }
        }

        private Task<bool> CallerIsAdminAsync(int userId)
        {
            return _context.UserRoles.AnyAsync(ur => ur.UserId == userId && ur.Role.Name == "Administrator");
        }
    }
}
