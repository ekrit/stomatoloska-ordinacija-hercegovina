using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class ServiceService : BaseCRUDService<ServiceResponse, ServiceSearchObject, Service, ServiceUpsertRequest, ServiceUpsertRequest>, IServiceService
    {
        public ServiceService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Service> ApplyFilter(IQueryable<Service> query, ServiceSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            return query;
        }
    }
}
