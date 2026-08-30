using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    public class ProductController : BaseCRUDController<ProductResponse, ProductSearchObject, ProductUpsertRequest, ProductUpsertRequest>
    {
        private readonly IProductService _products;

        public ProductController(IProductService service) : base(service)
        {
            _products = service;
        }

        /// <summary>
        /// Serves one product image. List rows no longer carry picture bytes;
        /// a card that needs one fetches it here, so a page of results is small
        /// and images are cached per product by the client instead of being
        /// re-sent with every listing.
        /// </summary>
        [HttpGet("{id:int}/picture")]
        public async Task<IActionResult> Picture(int id)
        {
            var bytes = await _products.GetPictureAsync(id);
            if (bytes == null || bytes.Length == 0)
            {
                return NotFound();
            }

            return File(bytes, ImageContentType.For(bytes));
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<ProductResponse> Create([FromBody] ProductUpsertRequest request)
        {
            return await base.Create(request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<ProductResponse?> Update(int id, [FromBody] ProductUpsertRequest request)
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
