using SOH.Model.Requests;
using SOH.Model.Responses;

namespace SOH.Services.Interfaces;

public interface IRecommendationService
{
    Task<IReadOnlyList<RecommendedProductResponse>> GetRecommendationsAsync(int userId, int take, CancellationToken cancellationToken = default);

    Task TrackInteractionAsync(int userId, ProductInteractionTrackRequest request, CancellationToken cancellationToken = default);
}
