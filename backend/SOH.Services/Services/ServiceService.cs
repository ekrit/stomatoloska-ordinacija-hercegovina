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

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.FTS) ||
                    x.Description.Contains(search.FTS));
            }

            return query;
        }

        protected override async Task BeforeDelete(Service entity)
        {
            if (await _context.Appointments.AnyAsync(a => a.ServiceId == entity.Id))
            {
                throw new BusinessException("Usluga se ne može obrisati jer postoje termini koji je koriste.");
            }
        }
    }
}
