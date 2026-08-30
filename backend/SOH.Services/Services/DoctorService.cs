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
    public class DoctorService : BaseCRUDService<DoctorResponse, DoctorSearchObject, Doctor, DoctorUpsertRequest, DoctorUpsertRequest>, IDoctorService
    {
        public DoctorService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Doctor> ApplyFilter(IQueryable<Doctor> query, DoctorSearchObject search)
        {
            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            if (!string.IsNullOrEmpty(search.FirstName))
            {
                query = query.Where(x => x.FirstName.Contains(search.FirstName));
            }

            if (!string.IsNullOrEmpty(search.LastName))
            {
                query = query.Where(x => x.LastName.Contains(search.LastName));
            }

            if (!string.IsNullOrEmpty(search.Specialization))
            {
                query = query.Where(x => x.Specialization.Contains(search.Specialization));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.FirstName.Contains(search.FTS) ||
                    x.LastName.Contains(search.FTS) ||
                    x.Specialization.Contains(search.FTS));
            }

            return query;
        }

        /// <summary>
        /// The Doctor primary key is the UserId, so a second profile for the
        /// same user would be a raw key violation surfacing as a 500. Check it
        /// here and also confirm the user exists, and copy the name from the
        /// user account so the two cannot be created out of step.
        /// </summary>
        protected override async Task BeforeInsert(Doctor entity, DoctorUpsertRequest request)
        {
            var user = await _context.Users
                .AsNoTracking()
                .Where(u => u.Id == request.UserId)
                .Select(u => new { u.FirstName, u.LastName })
                .FirstOrDefaultAsync()
                ?? throw new NotFoundException("Korisnik nije pronađen.");

            if (await _context.Doctors.AnyAsync(d => d.UserId == request.UserId))
            {
                throw new BusinessException("Ovaj korisnik već ima doktorski profil.");
            }

            entity.FirstName = user.FirstName;
            entity.LastName = user.LastName;

            // Rating is earned from reviews, never set by the caller.
            entity.Rating = 0m;
        }

        protected override Task BeforeUpdate(Doctor entity, DoctorUpsertRequest request)
        {
            // Identity and the aggregate rating stay server-owned; the admin
            // form edits the specialization and biography.
            request.UserId = entity.UserId;
            request.FirstName = entity.FirstName;
            request.LastName = entity.LastName;
            request.Rating = entity.Rating;
            return Task.CompletedTask;
        }

        protected override async Task BeforeDelete(Doctor entity)
        {
            if (await _context.Appointments.AnyAsync(a => a.DoctorId == entity.UserId))
            {
                throw new BusinessException("Doktor se ne može obrisati jer postoje termini koji ga koriste.");
            }

            if (await _context.Reviews.AnyAsync(r => r.DoctorId == entity.UserId))
            {
                throw new BusinessException("Doktor se ne može obrisati jer postoje recenzije koje ga koriste.");
            }
        }
    }
}
