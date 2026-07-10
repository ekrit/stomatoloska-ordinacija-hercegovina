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
    public class OrderService : BaseCRUDService<OrderResponse, OrderSearchObject, Order, OrderUpsertRequest, OrderUpsertRequest>, IOrderService
    {
        public OrderService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        // The order total always comes from the catalog price, never the client.
        protected override async Task BeforeInsert(Order entity, OrderUpsertRequest request)
        {
            entity.TotalAmount = await ComputeTotalAsync(request.ProductId, request.Quantity);
        }

        protected override async Task BeforeUpdate(Order entity, OrderUpsertRequest request)
        {
            entity.TotalAmount = await ComputeTotalAsync(request.ProductId, request.Quantity);
        }

        private async Task<decimal> ComputeTotalAsync(int productId, int quantity)
        {
            var price = await _context.Products
                .Where(p => p.Id == productId)
                .Select(p => (decimal?)p.Price)
                .FirstOrDefaultAsync()
                ?? throw new NotFoundException("Proizvod nije pronađen.");

            var qty = quantity < 1 ? 1 : quantity;
            return price * qty;
        }

        protected override IQueryable<Order> ApplyFilter(IQueryable<Order> query, OrderSearchObject search)
        {
            query = query
                .Include(x => x.Product)
                .Include(x => x.Patient);

            if (search.PatientId.HasValue)
            {
                query = query.Where(x => x.PatientId == search.PatientId.Value);
            }

            if (search.CreatedFrom.HasValue)
            {
                query = query.Where(x => x.CreatedAt >= search.CreatedFrom.Value);
            }

            if (search.CreatedTo.HasValue)
            {
                query = query.Where(x => x.CreatedAt <= search.CreatedTo.Value);
            }

            return query.OrderByDescending(x => x.CreatedAt);
        }

        public override async Task<OrderResponse?> GetByIdAsync(int id)
        {
            var entity = await _context.Orders
                .Include(x => x.Product)
                .Include(x => x.Patient)
                .FirstOrDefaultAsync(x => x.Id == id);
            if (entity == null)
                return null;

            return MapToResponse(entity);
        }
    }
}
