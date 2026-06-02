# Phase 2 - Residuals and Rubric Compliance

_Follow-up to the "SOH RSII 2025/26 - Cleanup + Rubric Compliance Pass" (Phases
0-7, complete on `main`). This phase closes the remaining gaps found in a deep
audit of the rubric PDF (`RSII_Upute_za_izradu_seminarskog_rada_2025_26.pdf`),
the seminar proposal docx, and `docs/plan-seminar-vs-solution-gap.md` against the
actual code in `backend/`, `mobile/`, and `desktop/`._

## Audit findings (why this phase exists)

- **Functional regression - patient cancel.** Mobile "Cancel" calls
  `PUT /Appointment/{id}` (`appointmentIdPut`), but `AppointmentController.Update`
  is `[Authorize(Roles=Administrator,Doctor)]`, so a patient cancel returns 403.
  (The paid path is fine: `PaymentService.RefundAsync` cancels the appointment.)
- **Notifications (rubric 7.2).** No notification is raised for payment events;
  the mobile list hides `createdAt` and does not auto-refresh while open.
- **Password rules (rubric 4).** Changing your own password does not require the
  old password; `UserUpsertRequest` has no `OldPassword`.
- **Authorization (rubric 5).** `GET /MedicalRecord` and `GET /Patient` are
  unscoped - any authenticated user can list all medical records / patients.
- **Pagination (rubric 8.2).** `UserService` paging bypasses the `MaxPageSize`
  clamp; `NotificationsController` `take` is uncapped.
- **Server-owned price (rubric 7.1).** `OrderService` passes the client
  `TotalAmount` straight through; mobile "Quick order" sends a client price and
  has no confirmation dialog.
- **PayPal webhook (rubric 7.1).** Signature check is a sandbox shortcut (header
  id match only), not `verify-webhook-signature`; refund is not idempotent.
- **Docker (rubric 3.2).** API + worker services have `build:` but no explicit
  versioned `image:` tags.
- **Docs drift.** `README.md` claims "collaborative" recommendations while the
  implementation and `docs/recommender-dokumentacija.md` are
  content + popularity + behavioral only.
- **Dead control (rubric 3.4 / 8.1).** The desktop admin Settings screen is a
  non-functional placeholder.

## Tickets

Each ticket lists the layers it touches and its acceptance criteria (AC). Work in
order; commit after each.

| ID | Layer | Description | AC |
|----|-------|-------------|----|
| P2.1 | api + mobile | Add `AppointmentService.CancelOwnAsync` + `POST /Appointment/{id}/cancel` (Patient/Doctor/Admin) with ownership + state-machine validation, notification, activity log; reject when a Paid payment exists ("refund first"). Repoint mobile cancel via `soh_extra_api.dart`. | Patient cancels an unpaid upcoming appointment with no 403; it moves to the Cancelled tab. |
| P2.2 | api | Notify the patient on capture (Paid) and on refund (`PaymentService` + webhook). | Paying/refunding creates a notification visible in the list. |
| P2.3 | mobile | Notifications list shows `createdAt` and auto-refreshes (RefreshIndicator + periodic refresh while the sheet is open). | Timestamp shown; list updates without reopening. |
| P2.4 | api + mobile + desktop | Add optional `OldPassword` to `UserUpsertRequest`; in `UserService.UpdateAsync`, when a non-admin changes their own password require + verify `OldPassword` (admin editing others unchanged). Add a current-password field to mobile profile + desktop self password change. | Self change with a wrong/missing old password is rejected with a clear message; admin path unaffected. |
| P2.5 | api | Scope `GET /MedicalRecord` (patient -> own; doctor/admin -> all) and restrict `GET /Patient` list to Doctor/Admin; `RoleController` list to Administrator. | A patient JWT cannot list other patients' medical records. |
| P2.6 | api | Clamp `UserService` page size to `MaxPageSize`; clamp `NotificationsController` `take` to [1,100]. | Oversized page requests are capped. |
| P2.7 | api + mobile | `OrderService` computes `TotalAmount = Product.Price * Quantity` server-side (ignore client value); mobile "Quick order" gets a confirmation dialog. | Tampered client amount is ignored; order placement needs confirmation. |
| P2.8 | api | Implement `POST /v1/notifications/verify-webhook-signature` in `PayPalGateway` (accept-all only when no webhook id is configured); add a refund idempotency short-circuit when already Refunded. | Invalid signature -> 401; double refund is a no-op. |
| P2.9 | desktop | Remove the non-functional Settings placeholder screen + its quick action. | No dead control remains. |
| P2.10 | backend/docker | Add explicit versioned `image:` tags to API + worker services. | Compose builds with pinned local tags; infra images stay version-pinned. |
| P2.11 | docs | Fix `README.md`: recommendations are content + popularity + behavioral (drop "collaborative"); describe notifications accurately; verify credentials/run steps. | README matches code + recommender doc. |
| P2.12 | docs | Update `docs/plan-seminar-vs-solution-gap.md` to final status. | Gap doc reflects this phase. |

## Verification

- `dotnet build backend/app.sln` -> 0 errors.
- `dart analyze lib` in `mobile/` and `desktop/` -> 0 errors.
- Working tree clean on `main`; one focused commit per ticket; secrets never
  committed.

## Out of scope (deferred, with rubric justification)

- **Collaborative filtering.** The seminar doc frames it as a later phase; the
  rubric only requires a simpler documented recommender that matches its
  documentation, which the current content + popularity + behavioral hybrid
  already exceeds.
- **Full product shop / cart / multi-item checkout + product PayPal.** The rubric
  warns the theme must not be classic product eCommerce; appointment
  booking + payment is the primary order flow and "kreiranje narudzbe" is
  optional ("eventualno"), already covered by the orders list + Quick order.
- **Mobile SignalR live client.** The rubric accepts "SignalR ili polling"; the
  polling badge + list refresh satisfies it without a redundant Dart hub client
  (the backend SignalR hub stays available).
- **Rich office hours/contact editing + full OpenAPI client regen.** The backend
  already stores the fields; surfacing them needs a client regen that risks broad
  breakage, and name-based city CRUD already satisfies the reference-data
  requirement.
- **Explicit CORS policy.** Clients are native Flutter (no browser origin), so
  CORS does not apply; an empty policy would be noise.
- **Real admin settings/config module.** Not in the seminar proposal; the
  placeholder is removed instead (P2.9).
