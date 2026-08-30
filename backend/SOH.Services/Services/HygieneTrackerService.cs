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
        protected override async Task BeforeInsert(HygieneTracker entity, HygieneTrackerUpsertRequest request)
        {
            if (_currentUser.IsPatient && _currentUser.UserId is int callerId)
            {
                entity.PatientId = callerId;
            }

            // The diary holds one entry per patient per day. Only the date part
            // is meaningful, so it is normalised before the check — otherwise
            // two entries differing by a timestamp would both be accepted.
            entity.Date = entity.Date.Date;

            await EnsureNoEntryForDayAsync(entity.PatientId, entity.Date, ignoreId: null);
        }

        // An existing entry keeps its patient; the request shares the insert
        // model, so Mapster would otherwise reassign it on update.
        protected override async Task BeforeUpdate(HygieneTracker entity, HygieneTrackerUpsertRequest request)
        {
            request.PatientId = entity.PatientId;
            request.Date = request.Date.Date;

            await EnsureNoEntryForDayAsync(entity.PatientId, request.Date, ignoreId: entity.Id);
        }

        /// <summary>
        /// Guards the one-entry-per-day rule in the service as well as in the
        /// database. The unique index is the real invariant — two concurrent
        /// POSTs can both pass this check — but hitting it raw would surface as
        /// a 500, so the common case is caught here with a clear message.
        /// </summary>
        private async Task EnsureNoEntryForDayAsync(int patientId, DateTime day, int? ignoreId)
        {
            var exists = await _context.HygieneTrackers
                .AsNoTracking()
                .Where(h => ignoreId == null || h.Id != ignoreId.Value)
                .AnyAsync(h => h.PatientId == patientId && h.Date == day.Date);

            if (exists)
            {
                throw new BusinessException(
                    "Za ovaj dan već postoji zapis o higijeni. Uredite postojeći zapis umjesto kreiranja novog.");
            }
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
