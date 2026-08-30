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
        private readonly ICurrentUserAccessor _currentUser;

        public OrderService(SOHDbContext context, IMapper mapper, ICurrentUserAccessor currentUser) : base(context, mapper)
        {
            _currentUser = currentUser;
        }

        /// <summary>
        /// A patient orders for themselves. The PatientId in the request is
        /// client input, so it is replaced with the identity from the JWT — a
        /// direct API call cannot place an order in another patient's name.
        /// Administrators, who order at the desk on a patient's behalf, keep
        /// the id they sent.
        /// </summary>
        private void BindOwnerToCaller(Order entity)
        {
            if (_currentUser.IsPatient && _currentUser.UserId is int callerId)
            {
                entity.PatientId = callerId;
            }
        }

        public async Task<RecordOwner?> GetOwnerAsync(int id, CancellationToken cancellationToken = default)
        {
            var owner = await _context.Orders
                .AsNoTracking()
                .Where(o => o.Id == id)
                .Select(o => new { o.PatientId })
                .FirstOrDefaultAsync(cancellationToken);

            return owner == null ? null : new RecordOwner(owner.PatientId, null);
        }

        // The order total always comes from the catalog price, never the client.
        protected override async Task BeforeInsert(Order entity, OrderUpsertRequest request)
        {
            BindOwnerToCaller(entity);
            entity.TotalAmount = await ComputeTotalAsync(request.ProductId, request.Quantity);
        }

        protected override async Task BeforeUpdate(Order entity, OrderUpsertRequest request)
        {
            // An existing order keeps its patient: the request shares the insert
            // model, so Mapster would otherwise move the order to another
            // patient on update.
            request.PatientId = entity.PatientId;
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

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Product.Name.Contains(search.FTS) ||
                    x.Patient.FirstName.Contains(search.FTS) ||
                    x.Patient.LastName.Contains(search.FTS));
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
