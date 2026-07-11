# Recommender system - documentation

This document describes the product recommender used by the patient mobile
app. It satisfies the seminar requirement to "implement and document a
recommender for one of the screens" (RSII_Upute, section *Funkcionalnosti i
poslovna logika*).

## Where it lives

- Service: [`backend/SOH.Services/Services/RecommendationService.cs`](../backend/SOH.Services/Services/RecommendationService.cs)
- Interface: `backend/SOH.Services/Interfaces/IRecommendationService.cs`
- Controller: [`backend/SOH.WebAPI/Controllers/RecommendationController.cs`](../backend/SOH.WebAPI/Controllers/RecommendationController.cs)
- Frontend consumer (patient home): [`mobile/lib/features/home/presentation/home_screen.dart`](../mobile/lib/features/home/presentation/home_screen.dart)
  via [`mobile/lib/core/api/soh_extra_api.dart`](../mobile/lib/core/api/soh_extra_api.dart) (`fetchRecommendations`).
- Detail + interaction: tapping a recommended card opens
  [`mobile/lib/features/home/presentation/product_detail_screen.dart`](../mobile/lib/features/home/presentation/product_detail_screen.dart),
  which lists every reason and posts a `DetailOpened` interaction (scored
  higher than a plain `View`).

## API surface

| Method | Route | Auth | Purpose |
|---|---|---|---|
| `GET` | `/Recommendation?take=8` | Bearer (Patient) | Returns up to `take` ranked products with score + per-product reasons. |
| `POST` | `/Recommendation/track` | Bearer (Patient) | Records that the patient interacted with a product (`View` or `DetailOpened`). Used as personal signal in the next call. |

Both routes use the JWT `NameIdentifier` claim as the user id; no body
needs to carry it.

## Algorithm: hybrid scoring

The recommender is intentionally a hybrid - the seminar rubric asks for a
recommender that is more than a fixed lookup. Three signals contribute to
the final score; weights are constants in the service so they are easy to
tune without a redeploy.

```
score(product, user)
  = WeightContent        * contentMatch(product, recent-services(user))
  + WeightPopularity     * log(1 + recent-order-count(product))
  + WeightPersonalViews  * log(1 + own-view-count(user, product))
  + WeightDetailOpened   * log(1 + own-detail-open-count(user, product))
```

Current weights (see `RecommendationService`):

| Signal | Weight | Window | Notes |
|---|---|---|---|
| Content (services -> product) | 3.5 | last 6 appointments in the last 9 months | Tokenized name + category name (FK to ProductCategory) + description; overlap with tokens from recent service names. Bounded `1 + 0.35 * overlap` capped at 4 to keep one strong match from dominating. |
| Popularity (clinic-wide orders) | 1.2 | last 90 days | Counted from `Order.ProductId` on `Orders.CreatedAt` (quantity summed). Logarithmic so a 100-order spike does not crowd everything else out. |
| Personal views | 2.0 | all time | `ProductInteractions` of kind `View`. Logarithmic for the same reason. |
| Detail opened | 3.0 | all time | `ProductInteractions` of kind `DetailOpened`. Stronger personal signal than a passive card view. |

The constants live at the top of the file:

```csharp
private const double WeightContent       = 3.5;
private const double WeightPopularity    = 1.2;
private const double WeightPersonalViews = 2.0;
private const double WeightDetailOpened  = 3.0;
```

The "content vs popular vs personal" mix is deliberate: a cold user with
no view history still sees relevant items (content + popular signal); a
returning user gets recommendations re-ranked toward items they already
care about.

## Explainability

The seminar rubric calls this out as required ("aplikacija prikazuje zašto
je preporučen taj proizvod"). Each `RecommendedProductResponse` carries a
`Reasons` list (de-duplicated) explaining which signals fired, in plain
English. Example:

```jsonc
{
  "product": { "id": 17, "name": "Whitening Toothpaste", "productCategoryId": 2, "productCategoryName": "Paste za zube", ... },
  "score": 8.4231,
  "reasons": [
    "Matches themes from your recent visits (shared terms: whitening, polish).",
    "Popular in the clinic lately (12 recent orders referencing this product).",
    "You viewed this product 2 time(s); we prioritize items you already explored.",
    "You opened detail for this product 3 time(s), so we surface it higher."
  ]
}
```

If no signal fires, the API still returns the product with a baseline
reason ("Baseline catalog item - explore the shop to personalize future
picks") so the UI never shows an empty justification chip.

## Data sources

| Signal | EF table | Field(s) used |
|---|---|---|
| Content | `Appointments` joined to `Services` | `PatientId`, `StartTime`, `Service.Name` |
| Popularity | `Orders` | `ProductId`, `Quantity`, `CreatedAt` |
| Personal views | `ProductInteractions` | `UserId`, `ProductId`, `Kind=View`, `CreatedAt` |
| Detail opened | `ProductInteractions` | `UserId`, `ProductId`, `Kind=DetailOpened`, `CreatedAt` |

`ProductInteractions` is populated by the mobile app via `POST
/Recommendation/track` whenever a patient opens a product card.

## Tokenization

`TokenizeToSet` lowercases the input, splits on a fixed punctuation set
(`' ' , . - / ( ) \n \r \t`), trims, and keeps tokens >= 3 characters. The
helper is intentionally simple: no stemming, no language-specific stopword
list. For Bosnian/English mixed clinic content this is good enough; the
content score caps overlap so a single noise token cannot swing the
ranking.

## Operational notes

- The endpoint clamps `take` to `[1, 50]` server-side so the mobile UI
  cannot exhaust the catalog through query parameter abuse.
- All EF queries are `AsNoTracking()` - the response is read-only.
- The recommender does not require RabbitMQ, SignalR, or any out-of-band
  job; it computes per-call from the latest DB state. Acceptable today
  because the product catalog is small.

## Future work (out of scope for the seminar)

- Move to a periodically-refreshed materialized view if the catalog grows.
- Promote the constants to `appsettings.json` so tuning does not need a
  redeploy.
- Add a "cold start" boost for items in categories never recommended yet,
  for product discovery.
