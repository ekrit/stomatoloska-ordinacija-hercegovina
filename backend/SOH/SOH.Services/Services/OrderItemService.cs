using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class OrderItemService : BaseCRUDService<OrderItemResponse, OrderItemSearchObject, OrderItem, OrderItemUpsertRequest, OrderItemUpsertRequest>, IOrderItemService
    {
        public OrderItemService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<OrderItem> ApplyFilter(IQueryable<OrderItem> query, OrderItemSearchObject search)
        {
            if (search.OrderId.HasValue)
            {
                query = query.Where(x => x.OrderId == search.OrderId.Value);
            }

            if (search.ProductId.HasValue)
            {
                query = query.Where(x => x.ProductId == search.ProductId.Value);
            }

            return query;
        }
    }
}
