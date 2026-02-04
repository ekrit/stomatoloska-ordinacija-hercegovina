using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class AdminService : BaseCRUDService<AdminResponse, AdminSearchObject, Admin, AdminUpsertRequest, AdminUpsertRequest>, IAdminService
    {
        public AdminService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Admin> ApplyFilter(IQueryable<Admin> query, AdminSearchObject search)
        {
            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            return query;
        }
    }
}
