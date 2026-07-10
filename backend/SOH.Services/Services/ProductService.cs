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
