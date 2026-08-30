using Microsoft.EntityFrameworkCore;
using SOH.Model.Exceptions;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using SOH.Services.Helpers;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class ProductService : BaseCRUDService<ProductResponse, ProductSearchObject, Product, ProductUpsertRequest, ProductUpsertRequest>, IProductService
    {
        public ProductService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public Task<byte[]?> GetPictureAsync(int id, CancellationToken cancellationToken = default)
        {
            return _context.Products
                .AsNoTracking()
                .Where(p => p.Id == id)
                .Select(p => p.Picture)
                .FirstOrDefaultAsync(cancellationToken);
        }

        protected override ProductResponse MapToResponse(Product entity)
        {
            var response = base.MapToResponse(entity);
            response.HasPicture = entity.Picture is { Length: > 0 };
            return response;
        }

        /// <summary>
        /// A catalog page shows thumbnails, not originals, and pictures are
        /// allowed up to 2 MB each — so a page of 30 rows could ship 60 MB the
        /// UI immediately downscales. List rows carry the flag; the bytes come
        /// from <c>GET /Product/{id}/picture</c> when a card actually needs one.
        /// </summary>
        protected override ProductResponse MapToListResponse(Product entity)
        {
            var response = MapToResponse(entity);
            response.Picture = null;
            return response;
        }

        protected override IQueryable<Product> ApplyFilter(IQueryable<Product> query, ProductSearchObject search)
        {
            query = query.Include(x => x.ProductCategory);

            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (search.ProductCategoryId.HasValue)
            {
                query = query.Where(x => x.ProductCategoryId == search.ProductCategoryId.Value);
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.FTS) ||
                    x.ProductCategory.Name.Contains(search.FTS) ||
                    x.Description.Contains(search.FTS));
            }

            return query;
        }

        public override async Task<ProductResponse?> GetByIdAsync(int id)
        {
            var entity = await _context.Products
                .Include(x => x.ProductCategory)
                .FirstOrDefaultAsync(x => x.Id == id);
            if (entity == null)
                return null;

            return MapToResponse(entity);
        }

        protected override async Task BeforeInsert(Product entity, ProductUpsertRequest request)
        {
            await EnsureCategoryExistsAsync(request.ProductCategoryId);
            ImageValidator.Validate(request.Picture, nameof(request.Picture));
        }

        protected override async Task BeforeUpdate(Product entity, ProductUpsertRequest request)
        {
            await EnsureCategoryExistsAsync(request.ProductCategoryId);
            ImageValidator.Validate(request.Picture, nameof(request.Picture));
        }

        protected override async Task BeforeDelete(Product entity)
        {
            if (await _context.Orders.AnyAsync(o => o.ProductId == entity.Id))
            {
                throw new BusinessException("Proizvod se ne može obrisati jer postoje narudžbe koje ga koriste.");
            }

            // Interaction history is recommender telemetry, not a business record;
            // it goes with the product.
            var interactions = _context.ProductInteractions.Where(pi => pi.ProductId == entity.Id);
            _context.ProductInteractions.RemoveRange(interactions);
        }

        private async Task EnsureCategoryExistsAsync(int categoryId)
        {
            if (!await _context.ProductCategories.AnyAsync(c => c.Id == categoryId))
            {
                throw new BusinessException("Odabrana kategorija proizvoda ne postoji.");
            }
        }
    }
}
