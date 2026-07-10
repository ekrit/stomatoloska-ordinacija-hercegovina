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

            return query;
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
