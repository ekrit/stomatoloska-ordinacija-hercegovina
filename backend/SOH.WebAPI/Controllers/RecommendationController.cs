using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize]
public class RecommendationController : ControllerBase
{
    private readonly IRecommendationService _recommendationService;

    public RecommendationController(IRecommendationService recommendationService)
    {
        _recommendationService = recommendationService;
    }

    [HttpGet("products")]
    public async Task<ActionResult<IReadOnlyList<RecommendedProductResponse>>> GetProducts([FromQuery] int take = 8)
    {
        var userId = CurrentUserId();
        if (userId == null)
            return Unauthorized();

        var list = await _recommendationService.GetRecommendationsAsync(userId.Value, take);
        return Ok(list);
    }

    [HttpPost("track")]
    public async Task<ActionResult> Track([FromBody] ProductInteractionTrackRequest request)
    {
        var userId = CurrentUserId();
        if (userId == null)
            return Unauthorized();

        await _recommendationService.TrackInteractionAsync(userId.Value, request);
        return NoContent();
    }

    private int? CurrentUserId()
    {
        var v = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(v, out var id) ? id : null;
    }
}
