using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class PatientService : BaseCRUDService<PatientResponse, PatientSearchObject, Patient, PatientUpsertRequest, PatientUpsertRequest>, IPatientService
    {
        public PatientService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Patient> ApplyFilter(IQueryable<Patient> query, PatientSearchObject search)
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

            if (!string.IsNullOrEmpty(search.Phone))
            {
                query = query.Where(x => x.Phone.Contains(search.Phone));
            }

            return query;
        }
    }
}
