using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IProductService : ICRUDService<ProductResponse, ProductSearchObject, ProductUpsertRequest, ProductUpsertRequest>
    {
        /// <summary>Raw picture bytes for one product, or null when it has none.</summary>
        Task<byte[]?> GetPictureAsync(int id, CancellationToken cancellationToken = default);
    }
}
