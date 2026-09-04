# Recommender system - documentation

This document describes the product recommender used by the patient mobile
app. It satisfies the seminar requirement to "implement and document a
recommender for one of the screens" (RSII_Upute, section *Funkcionalnosti i
poslovna logika*), and it implements the algorithm promised in the topic
proposal: **model-based Collaborative Filtering**.

## Where it lives

- Model (Matrix Factorization, singleton): [`backend/SOH.Services/Recommender/ProductRecommenderModel.cs`](../backend/SOH.Services/Recommender/ProductRecommenderModel.cs)
- Service: [`backend/SOH.Services/Services/RecommendationService.cs`](../backend/SOH.Services/Services/RecommendationService.cs)
- Interface: `backend/SOH.Services/Interfaces/IRecommendationService.cs`
- Controller: [`backend/SOH.WebAPI/Controllers/RecommendationController.cs`](../backend/SOH.WebAPI/Controllers/RecommendationController.cs)
- Startup training: [`backend/SOH.WebAPI/Program.cs`](../backend/SOH.WebAPI/Program.cs) trains the model once after seeding.
- Frontend consumer (patient home): [`mobile/lib/features/home/presentation/home_screen.dart`](../mobile/lib/features/home/presentation/home_screen.dart)
  via [`mobile/lib/core/api/soh_extra_api.dart`](../mobile/lib/core/api/soh_extra_api.dart) (`fetchRecommendations`).
- Detail + interaction: tapping a recommended card opens the product detail
  screen, which posts a `DetailOpened` interaction — a product-linked positive
  signal that joins the training matrix.

## Algorithm: model-based Collaborative Filtering (Matrix Factorization)

The recommender is **Matrix Factorization** implemented with **ML.NET**
(`Microsoft.ML` + `Microsoft.ML.Recommender`). It is genuinely collaborative:
it learns latent factors for users and products and can recommend a product a
user has never touched because users with a similar history preferred it — it
is not a category filter and not a popularity `SELECT`.

### Input: implicit-feedback matrix

Only the product-linked positive signals the application actually produces feed
the matrix. Every observed pair is a positive example with `Label = 1`; the
one-class trainer samples the unobserved cells as implicit negatives.

| Source | EF table | Pair produced |
|---|---|---|
| Product purchase | `Orders` | `(PatientId, ProductId)` |
| Opened product detail | `ProductInteractions` where `Kind = DetailOpened` | `(UserId, ProductId)` |

> **Note on reviews.** The topic proposal mentioned "positive product reviews"
> as an input. In this system `Review` rates an *appointment/doctor* (it has
> `AppointmentId`, `DoctorId`, `Rating`), not a product, so there is no
> product-level rating to feed the matrix. The product-linked positive signals
> that do exist — purchases and opened product details — are used instead. This
> is the one deviation from the proposal, made so the documented algorithm
> matches the real data model.

### Training

```
pipeline = MapValueToKey(UserId  -> UserIdEncoded)
         + MapValueToKey(ProductId -> ProductIdEncoded)
         + MatrixFactorization(one-class, implicit feedback)
```

One-class Matrix Factorization options (see `ProductRecommenderModel`):

| Option | Value | Meaning |
|---|---|---|
| `LossFunction` | `SquareLossOneClass` | Implicit-feedback (only positives observed). |
| `ApproximationRank` | 16 | Number of latent factors per user/product. |
| `NumberOfIterations` | 100 | Training iterations. |
| `Alpha` | 0.01 | Weight of the sampled unobserved entries. |
| `Lambda` | 0.025 | Regularization. |
| `C` | 0.00001 | Value assigned to unobserved entries. |

- **Trained at startup** (`Program.cs`, after seeding) so the first request is
  served from a warm model.
- **Retrained on new data**: `TrackInteractionAsync` marks the model stale, and
  the next recommendation request rebuilds it from the latest pairs.
- Training is guarded: with fewer than two users, two products, or four pairs
  there is nothing to collaborate on, so the model stays empty and every user
  falls back to popularity. Any training error is swallowed the same way — the
  recommender never breaks the request path.
- The catalog is small, so at train time every (trained user, product) score is
  precomputed into an immutable dictionary. Requests only read that dictionary,
  so the non-thread-safe ML.NET prediction engine never touches the request
  path.

### Ranking and cold start

For a user, products are ranked in two tiers so popularity can never outrank a
real personalized prediction:

1. **Matrix Factorization prediction** — products with a learned score for this
   user, highest first.
2. **Popularity fallback (cold start only)** — a user the model has never seen,
   or a product outside the trained matrix, is ranked by how many patients
   bought or opened it. This is explicitly a fallback, not the primary
   algorithm.

Already-purchased products are excluded from recommendations.

## Explainability

Each `RecommendedProductResponse` carries a de-duplicated `Reasons` list so the
UI can explain why the product was surfaced:

- MF hit: *"Model-based Collaborative Filtering (Matrix Factorization):
  pacijenti sa sličnim obrascima kupovine i pregleda proizvoda preferiraju ovaj
  proizvod."*
- Cold-start fallback: *"Popularno kod pacijenata (kupovine i otvaranja
  detalja: N) …"* or a baseline reason for a brand-new catalog item.

## API surface

| Method | Route | Auth | Purpose |
|---|---|---|---|
| `GET` | `/Recommendation/products?take=8` | Bearer (Patient) | Up to `take` ranked products with score + reasons. |
| `POST` | `/Recommendation/track` | Bearer (Patient) | Records a product interaction (`View` or `DetailOpened`); `DetailOpened` also feeds the matrix and marks the model stale. |

Both routes take the user id from the JWT `NameIdentifier` claim — the id is
never accepted from the URL or body, so one patient cannot request another
patient's recommendations. (The proposal sketched `/api/Product/Recommend/{userId}`;
the JWT-scoped route above is the implemented, safe equivalent.)

## Seed data

`RuntimeDataSeeder` seeds three patients with intentionally overlapping
purchases and opened details (all buy the sensitive paste and the floss; each
keeps items the others do not), so the model has shared structure to learn on
the very first run and can produce genuine cross-user recommendations for the
demo.

## Operational notes

- `take` is clamped to `[1, 50]` server-side.
- All EF reads are `AsNoTracking()`.
- The model lives in memory; there is no external training job. Acceptable
  because the catalog is small and training is fast.

## Future work (out of scope for the seminar)

- Periodic background retraining instead of lazy-on-request for a large catalog.
- Persisting the trained model between restarts.
- A dedicated product-review entity, which would add an explicit rating signal
  to the matrix.
