using Microsoft.EntityFrameworkCore;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class HygieneTrackerService : BaseCRUDService<HygieneTrackerResponse, HygieneTrackerSearchObject, HygieneTracker, HygieneTrackerUpsertRequest, HygieneTrackerUpsertRequest>, IHygieneTrackerService
    {
        private readonly ICurrentUserAccessor _currentUser;

        public HygieneTrackerService(SOHDbContext context, IMapper mapper, ICurrentUserAccessor currentUser) : base(context, mapper)
        {
            _currentUser = currentUser;
        }

        // A patient logs their own brushing. The PatientId in the request is
        // client input, so it is replaced with the identity from the JWT; only
        // an administrator keeps the id they sent.
        protected override Task BeforeInsert(HygieneTracker entity, HygieneTrackerUpsertRequest request)
        {
            if (_currentUser.IsPatient && _currentUser.UserId is int callerId)
            {
                entity.PatientId = callerId;
            }
            return Task.CompletedTask;
        }

        // An existing entry keeps its patient; the request shares the insert
        // model, so Mapster would otherwise reassign it on update.
        protected override Task BeforeUpdate(HygieneTracker entity, HygieneTrackerUpsertRequest request)
        {
            request.PatientId = entity.PatientId;
            return Task.CompletedTask;
        }

        public async Task<RecordOwner?> GetOwnerAsync(int id, CancellationToken cancellationToken = default)
        {
            var owner = await _context.HygieneTrackers
                .AsNoTracking()
                .Where(h => h.Id == id)
                .Select(h => new { h.PatientId })
                .FirstOrDefaultAsync(cancellationToken);

            return owner == null ? null : new RecordOwner(owner.PatientId, null);
        }

        protected override IQueryable<HygieneTracker> ApplyFilter(IQueryable<HygieneTracker> query, HygieneTrackerSearchObject search)
        {
            if (search.PatientId.HasValue)
            {
                query = query.Where(x => x.PatientId == search.PatientId.Value);
            }

            if (search.DateFrom.HasValue)
            {
                query = query.Where(x => x.Date >= search.DateFrom.Value);
            }

            if (search.DateTo.HasValue)
            {
                query = query.Where(x => x.Date <= search.DateTo.Value);
            }

            return query;
        }
    }
}
