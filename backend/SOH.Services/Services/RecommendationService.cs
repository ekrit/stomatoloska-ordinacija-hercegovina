using Microsoft.EntityFrameworkCore;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Services.Database;
using SOH.Services.Interfaces;
using SOH.Services.Recommender;
using MapsterMapper;

namespace SOH.Services.Services;

/// <summary>
/// Model-based Collaborative Filtering recommender for oral-hygiene products.
/// <para>
/// The ranking algorithm is <b>Matrix Factorization</b> (ML.NET, see
/// <see cref="IProductRecommenderModel"/>). The implicit-feedback matrix is
/// built from the product-linked positive signals the application actually
/// records — product purchases (<c>Orders</c>) and opened product details
/// (<c>ProductInteractions</c> of kind <c>DetailOpened</c>). Every such
/// (user, product) pair is a positive; the trainer learns latent user and
/// product factors and can therefore recommend a product the user never
/// touched because users with a similar history preferred it.
/// </para>
/// <para>
/// Popularity is <b>only</b> the cold-start fallback: a user the model has
/// never seen, or a product outside the trained matrix, is ranked by how many
/// patients bought or opened it. Every recommendation carries a plain-language
/// reason so the UI can explain why the product was surfaced.
/// </para>
/// <para>
/// Note on reviews: <c>Review</c> in this system rates an appointment/doctor,
/// not a product, so it is not a product-level signal and is deliberately not
/// fed into the matrix.
/// </para>
/// </summary>
public class RecommendationService : IRecommendationService
{
    private readonly SOHDbContext _context;
    private readonly IMapper _mapper;
    private readonly IProductRecommenderModel _model;

    public RecommendationService(SOHDbContext context, IMapper mapper, IProductRecommenderModel model)
    {
        _context = context;
        _mapper = mapper;
        _model = model;
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

        // A new interaction means the trained factors no longer reflect the
        // data; retrain lazily on the next recommendation request.
        _model.MarkStale();
    }

    public async Task<IReadOnlyList<RecommendedProductResponse>> GetRecommendationsAsync(int userId, int take, CancellationToken cancellationToken = default)
    {
        take = Math.Clamp(take, 1, 50);

        if (_model.IsStale)
        {
            var pairs = await LoadPositivePairsAsync(_context, cancellationToken);
            _model.Rebuild(pairs);
        }

        var products = await _context.Products
            .AsNoTracking()
            .Include(p => p.ProductCategory)
            .ToListAsync(cancellationToken);

        // Already-purchased products are not re-recommended.
        var purchased = await _context.Orders
            .AsNoTracking()
            .Where(o => o.PatientId == userId)
            .Select(o => o.ProductId)
            .Distinct()
            .ToListAsync(cancellationToken);
        var purchasedSet = purchased.ToHashSet();

        var popularity = await LoadPopularityAsync(_context, cancellationToken);

        var hasModel = _model.TryGetUserScores(userId, out var mfScores);

        // Tier 0 = Matrix Factorization prediction (primary), Tier 1 = popularity
        // fallback. Ordering by tier first keeps MF-ranked items above fallback
        // items so popularity never outranks a real personalized prediction.
        var scored = new List<(int Tier, double Score, string Name, RecommendedProductResponse Response)>();

        foreach (var p in products)
        {
            if (purchasedSet.Contains(p.Id))
                continue;

            var reasons = new List<string>();
            int tier;
            double score;

            if (hasModel && mfScores.TryGetValue(p.Id, out var mf))
            {
                tier = 0;
                score = mf;
                reasons.Add(
                    "Model-based Collaborative Filtering (Matrix Factorization): pacijenti sa sličnim obrascima kupovine i pregleda proizvoda preferiraju ovaj proizvod.");
            }
            else
            {
                tier = 1;
                var pop = popularity.TryGetValue(p.Id, out var c) ? c : 0;
                score = pop;
                reasons.Add(pop > 0
                    ? $"Popularno kod pacijenata (kupovine i otvaranja detalja: {pop}) — prijedlog dok model ne prikupi vaše interakcije."
                    : "Novo u katalogu — kupovinom i pregledom proizvoda personalizujemo buduće preporuke.");
            }

            scored.Add((tier, score, p.Name, new RecommendedProductResponse
            {
                Product = _mapper.Map<ProductResponse>(p),
                Reasons = reasons,
                Score = Math.Round(score, 4)
            }));
        }

        return scored
            .OrderBy(x => x.Tier)
            .ThenByDescending(x => x.Score)
            .ThenBy(x => x.Name)
            .Take(take)
            .Select(x => x.Response)
            .ToList();
    }

    /// <summary>
    /// The implicit-feedback matrix: product-linked positive (user, product)
    /// pairs from purchases and opened product details. Shared by the startup
    /// warm-up so training uses exactly the same signal as a lazy rebuild.
    /// </summary>
    public static async Task<IReadOnlyCollection<(int UserId, int ProductId)>> LoadPositivePairsAsync(
        SOHDbContext context, CancellationToken cancellationToken = default)
    {
        var orderPairs = await context.Orders
            .AsNoTracking()
            .Select(o => new { UserId = o.PatientId, o.ProductId })
            .ToListAsync(cancellationToken);

        var detailPairs = await context.ProductInteractions
            .AsNoTracking()
            .Where(i => i.Kind == ProductInteractionKind.DetailOpened)
            .Select(i => new { i.UserId, i.ProductId })
            .ToListAsync(cancellationToken);

        return orderPairs
            .Concat(detailPairs)
            .Select(x => (x.UserId, x.ProductId))
            .Distinct()
            .ToList();
    }

    /// <summary>
    /// Cold-start ranking: how many patients bought (quantity summed) or opened
    /// the detail of each product. Only used when Matrix Factorization has no
    /// score for the user/product.
    /// </summary>
    private static async Task<Dictionary<int, int>> LoadPopularityAsync(
        SOHDbContext context, CancellationToken cancellationToken)
    {
        var orderCounts = await context.Orders
            .AsNoTracking()
            .GroupBy(o => o.ProductId)
            .Select(g => new { ProductId = g.Key, Count = g.Sum(x => x.Quantity) })
            .ToListAsync(cancellationToken);

        var detailCounts = await context.ProductInteractions
            .AsNoTracking()
            .Where(i => i.Kind == ProductInteractionKind.DetailOpened)
            .GroupBy(i => i.ProductId)
            .Select(g => new { ProductId = g.Key, Count = g.Count() })
            .ToListAsync(cancellationToken);

        var popularity = new Dictionary<int, int>();
        foreach (var row in orderCounts)
            popularity[row.ProductId] = row.Count;
        foreach (var row in detailCounts)
            popularity[row.ProductId] = popularity.GetValueOrDefault(row.ProductId) + row.Count;

        return popularity;
    }

    private static ProductInteractionKind ParseKind(string kind)
    {
        return kind.Trim().Equals("DetailOpened", StringComparison.OrdinalIgnoreCase)
            ? ProductInteractionKind.DetailOpened
            : ProductInteractionKind.View;
    }
}
