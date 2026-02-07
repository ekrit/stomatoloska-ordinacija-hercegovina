using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class GenderService : BaseCRUDService<GenderResponse, GenderSearchObject, Gender, GenderUpsertRequest, GenderUpsertRequest>, IGenderService
    {
        public GenderService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Gender> ApplyFilter(IQueryable<Gender> query, GenderSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            return query;
        }

        protected override async Task BeforeInsert(Gender entity, GenderUpsertRequest request)
        {
            if (await _context.Genders.AnyAsync(g => g.Name == request.Name))
            {
                throw new InvalidOperationException("A gender with this name already exists.");
            }
        }

        protected override async Task BeforeUpdate(Gender entity, GenderUpsertRequest request)
        {
            if (await _context.Genders.AnyAsync(g => g.Name == request.Name && g.Id != entity.Id))
            {
                throw new InvalidOperationException("A gender with this name already exists.");
            }
        }
    }
} 