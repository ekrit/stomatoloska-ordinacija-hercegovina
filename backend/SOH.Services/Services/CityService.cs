using SOH.Model.Exceptions;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using SOH.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace SOH.Services.Services
{
    public class CityService : BaseCRUDService<CityResponse, CitySearchObject, City, CityUpsertRequest, CityUpsertRequest>, ICityService
    {
        public CityService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<City> ApplyFilter(IQueryable<City> query, CitySearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.FTS) ||
                    (x.Address != null && x.Address.Contains(search.FTS)));
            }

            return query;
        }

        protected override async Task BeforeInsert(City entity, CityUpsertRequest request)
        {
            if (await _context.Cities.AnyAsync(c => c.Name == request.Name))
            {
                throw new BusinessException("Grad s ovim nazivom već postoji.");
            }
        }

        protected override async Task BeforeUpdate(City entity, CityUpsertRequest request)
        {
            if (await _context.Cities.AnyAsync(c => c.Name == request.Name && c.Id != entity.Id))
            {
                throw new BusinessException("Grad s ovim nazivom već postoji.");
            }
        }

        protected override async Task BeforeDelete(City entity)
        {
            if (await _context.Users.AnyAsync(u => u.CityId == entity.Id))
            {
                throw new BusinessException("Grad se ne može obrisati jer postoje korisnici koji ga koriste.");
            }
        }
    }
} 