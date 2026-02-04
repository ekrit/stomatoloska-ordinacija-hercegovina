using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class RoomService : BaseCRUDService<RoomResponse, RoomSearchObject, Room, RoomUpsertRequest, RoomUpsertRequest>, IRoomService
    {
        public RoomService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Room> ApplyFilter(IQueryable<Room> query, RoomSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (search.IsAvailable.HasValue)
            {
                query = query.Where(x => x.IsAvailable == search.IsAvailable.Value);
            }

            return query;
        }
    }
}
