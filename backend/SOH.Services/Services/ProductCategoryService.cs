using SOH.Model.Exceptions;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class ProductCategoryService : BaseCRUDService<ProductCategoryResponse, ProductCategorySearchObject, ProductCategory, ProductCategoryUpsertRequest, ProductCategoryUpsertRequest>, IProductCategoryService
    {
        public ProductCategoryService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<ProductCategory> ApplyFilter(IQueryable<ProductCategory> query, ProductCategorySearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (search.IsActive.HasValue)
            {
                query = query.Where(x => x.IsActive == search.IsActive.Value);
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.FTS) ||
                    x.Description.Contains(search.FTS));
            }

            return query.OrderBy(x => x.Name);
        }

        protected override async Task BeforeInsert(ProductCategory entity, ProductCategoryUpsertRequest request)
        {
            if (await _context.ProductCategories.AnyAsync(c => c.Name == request.Name))
            {
                throw new BusinessException("Kategorija proizvoda s ovim nazivom već postoji.");
            }
        }

        protected override async Task BeforeUpdate(ProductCategory entity, ProductCategoryUpsertRequest request)
        {
            if (await _context.ProductCategories.AnyAsync(c => c.Name == request.Name && c.Id != entity.Id))
            {
                throw new BusinessException("Kategorija proizvoda s ovim nazivom već postoji.");
            }
        }

        protected override async Task BeforeDelete(ProductCategory entity)
        {
            if (await _context.Products.AnyAsync(p => p.ProductCategoryId == entity.Id))
            {
                throw new BusinessException("Kategorija se ne može obrisati jer postoje proizvodi koji je koriste.");
            }
        }
    }
}
