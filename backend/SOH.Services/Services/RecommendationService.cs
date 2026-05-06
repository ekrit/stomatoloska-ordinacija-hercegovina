using Microsoft.EntityFrameworkCore;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Services.Database;
using SOH.Services.Interfaces;
using MapsterMapper;

namespace SOH.Services.Services;

/// <summary>
/// Hybrid recommender: content (recent services vs product category/name),
/// popularity (order counts), and personal view history — all signals feed the score and explanations.
/// </summary>
public class RecommendationService : IRecommendationService
{
    private const double WeightContent = 3.5;
    private const double WeightPopularity = 1.2;
    private const double WeightPersonalViews = 2.0;

    private readonly SOHDbContext _context;
    private readonly IMapper _mapper;

    public RecommendationService(SOHDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task TrackInteractionAsync(int userId, ProductInteractionTrackRequest request, CancellationToken cancellationToken = default)
    {
        var kind = ParseKind(request.Kind);
        var exists = await _context.Products.AnyAsync(p => p.Id == request.ProductId, cancellationToken);
        if (!exists)
            return;

        _context.ProductInteractions.Add(new ProductInteraction
        {
            UserId = userId,
            ProductId = request.ProductId,
            Kind = kind,
            CreatedAt = DateTime.UtcNow
        });
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<IReadOnlyList<RecommendedProductResponse>> GetRecommendationsAsync(int userId, int take, CancellationToken cancellationToken = default)
    {
        take = Math.Clamp(take, 1, 50);

        var sinceOrders = DateTime.UtcNow.AddDays(-90);
        var orderCounts = await _context.OrderItems
            .AsNoTracking()
            .Where(oi => oi.Order.CreatedAt >= sinceOrders)
            .GroupBy(oi => oi.ProductId)
            .Select(g => new { ProductId = g.Key, Count = g.Count() })
            .ToDictionaryAsync(x => x.ProductId, x => x.Count, cancellationToken);

        var viewCounts = await _context.ProductInteractions
            .AsNoTracking()
            .Where(pi => pi.UserId == userId && pi.Kind == ProductInteractionKind.View)
            .GroupBy(pi => pi.ProductId)
            .Select(g => new { ProductId = g.Key, Count = g.Count() })
            .ToDictionaryAsync(x => x.ProductId, x => x.Count, cancellationToken);

        var serviceKeywords = await LoadRecentServiceKeywordsAsync(userId, cancellationToken);

        var products = await _context.Products.AsNoTracking().ToListAsync(cancellationToken);
        var scored = new List<RecommendedProductResponse>();

        foreach (var p in products)
        {
            var reasons = new List<string>();
            double score = 0;

            var contentScore = ComputeContentScore(p, serviceKeywords, reasons);
            score += WeightContent * contentScore;

            var pop = orderCounts.TryGetValue(p.Id, out var c) ? c : 0;
            if (pop > 0)
            {
                var popPart = Math.Log(1 + pop);
                score += WeightPopularity * popPart;
                reasons.Add($"Popular in the clinic lately ({pop} recent orders referencing this product).");
            }

            var views = viewCounts.TryGetValue(p.Id, out var vc) ? vc : 0;
            if (views > 0)
            {
                score += WeightPersonalViews * Math.Log(1 + views);
                reasons.Add($"You opened this product {views} time(s); we prioritize items you already explored.");
            }

            if (reasons.Count == 0)
            {
                reasons.Add("Baseline catalog item — explore the shop to personalize future picks.");
            }

            scored.Add(new RecommendedProductResponse
            {
                Product = _mapper.Map<ProductResponse>(p),
                Reasons = reasons.Distinct().ToList(),
                Score = Math.Round(score, 4)
            });
        }

        return scored
            .OrderByDescending(x => x.Score)
            .ThenBy(x => x.Product.Name)
            .Take(take)
            .ToList();
    }

    private static ProductInteractionKind ParseKind(string kind)
    {
        return kind.Trim().Equals("DetailOpened", StringComparison.OrdinalIgnoreCase)
            ? ProductInteractionKind.DetailOpened
            : ProductInteractionKind.View;
    }

    private static double ComputeContentScore(Product p, HashSet<string> serviceKeywords, List<string> reasons)
    {
        if (serviceKeywords.Count == 0)
            return 0;

        var productTokens = TokenizeToSet($"{p.Name} {p.Category} {p.Description}");
        var overlap = productTokens.Intersect(serviceKeywords).ToList();
        if (overlap.Count == 0)
            return 0;

        reasons.Add(
            $"Matches themes from your recent visits (shared terms: {string.Join(", ", overlap.Take(4))}).");
        return Math.Min(1 + overlap.Count * 0.35, 4);
    }

    private async Task<HashSet<string>> LoadRecentServiceKeywordsAsync(int userId, CancellationToken cancellationToken)
    {
        var since = DateTime.UtcNow.AddMonths(-9);
        var names = await _context.Appointments
            .AsNoTracking()
            .Where(a => a.PatientId == userId && a.StartTime >= since)
            .OrderByDescending(a => a.StartTime)
            .Take(6)
            .Join(_context.Services, a => a.ServiceId, s => s.Id, (_, s) => s.Name)
            .ToListAsync(cancellationToken);

        var set = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (var n in names)
        {
            foreach (var t in TokenizeToSet(n))
                set.Add(t);
        }
        return set;
    }

    private static HashSet<string> TokenizeToSet(string text)
    {
        var set = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        if (string.IsNullOrWhiteSpace(text))
            return set;

        foreach (var raw in text.ToLowerInvariant().Split(
                     new[] { ' ', ',', '.', '-', '/', '(', ')', '\n', '\r', '\t' },
                     StringSplitOptions.RemoveEmptyEntries))
        {
            var w = raw.Trim();
            if (w.Length >= 3)
                set.Add(w);
        }
        return set;
    }
}
