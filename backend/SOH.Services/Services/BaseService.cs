using SOH.Services.Database;
using Microsoft.EntityFrameworkCore;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public abstract class BaseService<T, TSearch, TEntity> : IService<T, TSearch> where T : class where TSearch : BaseSearchObject where TEntity : class
    {
        protected readonly SOHDbContext _context;
        protected readonly IMapper _mapper;

        public BaseService(SOHDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        // Hard ceiling on a single page so a client cannot pull the entire
        // table in one request (rubric flags unbounded list endpoints).
        protected const int MaxPageSize = 100;

        public virtual async Task<PagedResult<T>> GetAsync(TSearch search)
        {
            var query = _context.Set<TEntity>().AsQueryable();
            query = ApplyFilter(query, search);

            int? totalCount = null;
            if (search.IncludeTotalCount)
            {
                totalCount = await query.CountAsync();
            }

            var pageSize = Math.Clamp(search.PageSize ?? 30, 1, MaxPageSize);
            var page = Math.Max(search.Page ?? 0, 0);
            query = query.Skip(page * pageSize).Take(pageSize);

            var list = await query.ToListAsync();
            return new PagedResult<T>
            {
                Items = list.Select(MapToResponse).ToList(),
                TotalCount = totalCount
            };
        }

        protected virtual IQueryable<TEntity> ApplyFilter(IQueryable<TEntity> query, TSearch search)
        {
            return query;
        }

        public virtual async Task<T?> GetByIdAsync(int id)
        {
            var entity = await _context.Set<TEntity>().FindAsync(id);
            if (entity == null)
                return null;

            return MapToResponse(entity);
        }

        protected virtual T MapToResponse(TEntity entity)
        {
            return _mapper.Map<T>(entity);
        }

    }
}