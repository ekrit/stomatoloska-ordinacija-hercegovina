using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    public class ProductCategoryController : BaseCRUDController<ProductCategoryResponse, ProductCategorySearchObject, ProductCategoryUpsertRequest, ProductCategoryUpsertRequest>
    {
        public ProductCategoryController(IProductCategoryService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<ProductCategoryResponse> Create([FromBody] ProductCategoryUpsertRequest request)
        {
            return await base.Create(request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<ProductCategoryResponse?> Update(int id, [FromBody] ProductCategoryUpsertRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<bool> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
}
