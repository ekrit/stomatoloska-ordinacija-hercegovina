using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class DoctorNoteService : BaseCRUDService<DoctorNoteResponse, DoctorNoteSearchObject, DoctorNote, DoctorNoteUpsertRequest, DoctorNoteUpsertRequest>, IDoctorNoteService
    {
        public DoctorNoteService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<DoctorNote> ApplyFilter(IQueryable<DoctorNote> query, DoctorNoteSearchObject search)
        {
            if (search.AppointmentId.HasValue)
            {
                query = query.Where(x => x.AppointmentId == search.AppointmentId.Value);
            }

            return query;
        }
    }
}
