using Microsoft.ML;
using Microsoft.ML.Trainers;

namespace SOH.Services.Recommender;

/// <summary>
/// In-memory, model-based Collaborative Filtering recommender.
/// <para>
/// The algorithm is <b>Matrix Factorization</b> (ML.NET
/// <c>Microsoft.ML.Recommender</c>) over an implicit-feedback matrix: every
/// observed (user, product) interaction is a positive example (Label = 1) and
/// the one-class trainer samples the unobserved cells as implicit negatives.
/// Training learns latent factors for users and products, so a user can be
/// recommended a product they never touched because users with similar
/// behaviour preferred it — this is what separates it from a category filter
/// or a plain popularity <c>SELECT</c>.
/// </para>
/// <para>
/// The model is a singleton. It is trained once at startup and rebuilt when new
/// interactions arrive (the service marks it stale). Because the catalog is
/// small, every (trained user, product) score is precomputed at train time into
/// an immutable dictionary; requests only read that dictionary, so the
/// non-thread-safe ML.NET prediction engine never touches the request path.
/// Users or products the model has never seen (cold start) simply have no
/// score here and the service falls back to popularity.
/// </para>
/// </summary>
public interface IProductRecommenderModel
{
    /// <summary>True when new data has arrived since the last successful train.</summary>
    bool IsStale { get; }

    /// <summary>Flags the model for a rebuild on the next recommendation request.</summary>
    void MarkStale();

    /// <summary>
    /// Trains the Matrix Factorization model from the given implicit-positive
    /// (user, product) pairs and precomputes every score. Never throws: a
    /// training failure (too little data) leaves an empty model so callers fall
    /// back to popularity.
    /// </summary>
    void Rebuild(IReadOnlyCollection<(int UserId, int ProductId)> positivePairs);

    /// <summary>
    /// Returns the precomputed product scores for a user, or false when the user
    /// was not part of the trained matrix (cold start).
    /// </summary>
    bool TryGetUserScores(int userId, out IReadOnlyDictionary<int, double> productScores);
}

public sealed class ProductRecommenderModel : IProductRecommenderModel
{
    private sealed class Rating
    {
        public float UserId { get; set; }
        public float ProductId { get; set; }
        public float Label { get; set; }
    }

    private sealed class ScorePrediction
    {
        public float Score { get; set; }
    }

    private static readonly IReadOnlyDictionary<int, double> EmptyScores =
        new Dictionary<int, double>();

    private readonly object _gate = new();

    // Replaced atomically by Rebuild; readers take the reference and never mutate it.
    private Dictionary<int, Dictionary<int, double>> _scores = new();

    private volatile bool _stale = true;

    public bool IsStale => _stale;

    public void MarkStale() => _stale = true;

    public bool TryGetUserScores(int userId, out IReadOnlyDictionary<int, double> productScores)
    {
        var snapshot = _scores;
        if (snapshot.TryGetValue(userId, out var inner))
        {
            productScores = inner;
            return true;
        }

        productScores = EmptyScores;
        return false;
    }

    public void Rebuild(IReadOnlyCollection<(int UserId, int ProductId)> positivePairs)
    {
        lock (_gate)
        {
            try
            {
                _scores = Train(positivePairs);
            }
            catch
            {
                // Too few interactions, or a native/training error: keep an empty
                // model so every user falls back to popularity. The recommender
                // must never break the request path.
                _scores = new Dictionary<int, Dictionary<int, double>>();
            }
            finally
            {
                _stale = false;
            }
        }
    }

    private static Dictionary<int, Dictionary<int, double>> Train(
        IReadOnlyCollection<(int UserId, int ProductId)> pairs)
    {
        var result = new Dictionary<int, Dictionary<int, double>>();

        var users = pairs.Select(p => p.UserId).Distinct().ToArray();
        var products = pairs.Select(p => p.ProductId).Distinct().ToArray();

        // Matrix Factorization needs at least two users and two products with a
        // handful of interactions to find any shared latent structure; below
        // that there is nothing to collaborate on and popularity is the honest
        // answer.
        if (users.Length < 2 || products.Length < 2 || pairs.Count < 4)
            return result;

        var ml = new MLContext(seed: 0);

        var ratings = pairs
            .Select(p => new Rating { UserId = p.UserId, ProductId = p.ProductId, Label = 1f })
            .ToList();
        var data = ml.Data.LoadFromEnumerable(ratings);

        // One-class Matrix Factorization for implicit feedback: only positives
        // are observed; Alpha/C weight the sampled unobserved entries.
        var options = new MatrixFactorizationTrainer.Options
        {
            MatrixColumnIndexColumnName = "UserIdEncoded",
            MatrixRowIndexColumnName = "ProductIdEncoded",
            LabelColumnName = nameof(Rating.Label),
            LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
            Alpha = 0.01,
            Lambda = 0.025,
            C = 0.00001,
            ApproximationRank = 16,
            NumberOfIterations = 100,
            Quiet = true,
        };

        var pipeline = ml.Transforms.Conversion
            .MapValueToKey(outputColumnName: "UserIdEncoded", inputColumnName: nameof(Rating.UserId))
            .Append(ml.Transforms.Conversion.MapValueToKey(
                outputColumnName: "ProductIdEncoded", inputColumnName: nameof(Rating.ProductId)))
            .Append(ml.Recommendation().Trainers.MatrixFactorization(options));

        var model = pipeline.Fit(data);
        var engine = ml.Model.CreatePredictionEngine<Rating, ScorePrediction>(model);

        foreach (var u in users)
        {
            var inner = new Dictionary<int, double>();
            foreach (var p in products)
            {
                var prediction = engine.Predict(new Rating { UserId = u, ProductId = p });
                var score = prediction.Score;
                if (float.IsNaN(score) || float.IsInfinity(score))
                    continue;

                inner[(int)p] = score;
            }

            if (inner.Count > 0)
                result[(int)u] = inner;
        }

        return result;
    }
}
