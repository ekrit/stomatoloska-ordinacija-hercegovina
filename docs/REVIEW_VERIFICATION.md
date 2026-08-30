# Verifikacija dorada po review-u

Statička provjera svih 19 implementiranih stavki, nakon što su sve mergeane u
`main`. Cilj: potvrditi da svaka provjera stvarno postoji u kodu, da nema puta
koji je zaobilazi, i da su ručno pisane migracije konzistentne sa modelom.

> **Ograničenje:** u okruženju u kojem je provjera rađena i dalje nema `dotnet`
> SDK-a ni `flutter` alata (`command -v dotnet` / `flutter` → prazno). Ovo je
> dakle **statička** provjera (čitanje koda, uparivanje potpisa, prisutnost
> atributa i property-ja), a **ne** kompajliranje. Blok 1 se može stvarno
> zatvoriti tek lokalnim `dotnet build` + `dotnet ef migrations add` + `flutter
> analyze`. Vidi na dnu.

## Blok 1 — kompajliranje i konzistentnost

| Provjera | Nalaz |
|---|---|
| `[Migration("…")]` ID == ime fajla (svih 5 ručnih migracija) | **OK** — sve se poklapaju |
| Svaka ručna migracija ima inline `[DbContext]` + `[Migration]` (nema `.Designer.cs`) | **OK** — `Database.Migrate()` ih pronalazi |
| Nove entitete (`AppointmentStatusHistory`, `AppointmentStatusType`, `PaymentStatusType`, `PasswordResetToken`) imaju `DbSet<>` | **OK** |
| Iste entitete imaju blok u `SOHDbContextModelSnapshot.cs` (entitet + relacija) | **OK** |
| Nova polja `Payment` (`Currency`, `ChargedAmount`, `ChargedCurrency`, `PaidAt`) u snapshotu | **OK** |
| Nova polja `Appointment` (`PatientComplaint`, `DeclineReason`, `CancelReason`) u snapshotu | **OK** |
| Hygiene unique index `(PatientId, Date)` u snapshotu | **OK** |
| Svi property-ji novih entiteta prisutni u snapshot property-blokovima (uklj. nullable `ChangedByUserId`) | **OK** |
| DI registracije za `IAppointmentStatusTypeService`, `IPaymentStatusTypeService`, `IPasswordResetPublisher` u `Program.cs` | **OK** |
| Nema dupliranih `[Route]` na `StatusTypeControllers` (naslijeđen iz baze) | **OK** — 0 dodatnih |
| `[Range]` request fajlovi imaju `using System.ComponentModel.DataAnnotations` | **OK** (6/6) |
| `PayPalGateway` ima `using SOH.Services.Database` za `MoneyPolicy` | **OK** |
| `HygieneTrackerService` ima `using` za `Exceptions` + EF | **OK** |
| `UserService` ima `using System.Text` + `System.Security.Cryptography` za reset | **OK** |
| `CancelOwnAsync` potpis (controller ↔ service ↔ interface) usklađen na 4 arg | **OK** |
| `/Product/{id}/picture` i `/Users/{id}/picture` ne kolidiraju (različiti kontroleri) | **OK** |

## Blok 2 — stavke 1–6

| Stavka | Nalaz |
|---|---|
| **4** `AuthenticateAsync` odbija `!IsActive` prije tokena (reset tokovi isto) | **OK** |
| **1** Svih 7 GetById endpointa ima ownership provjeru; svih 7 servisa ima `GetOwnerAsync` | **OK** |
| **2** Patient identitet iz JWT-a na insert (Appointment/Order/Hygiene); `PatientId` pinovan na update | **OK** |
| **3** Doktor cancel scope (`AppointmentActor.Doctor when …`); `MedicalRecordService` provjerava doktora appointmenta | **OK** |
| **5** `RegisterPatientAsync(…, DateTime dateOfBirth)` non-nullable; `Register` prosljeđuje; `CompleteProfile` uklonjen (0 referenci) | **OK** |
| **6** `SyncDomainProfilesAsync` (4 poziva); Doctor uloga bez profila se odbija | **OK** |

## Blok 3 — stavke 7–11

| Stavka | Nalaz |
|---|---|
| **7** `MoneyPolicy.BamPerEur = 1.95583`; konverzija u `PaymentService`; PayPal naplaćuje `ProviderCurrency` | **OK** |
| **8** `VerifyWebhookAsync` vraća `_allowUnverifiedWebhooks` (0 `return true;`) — fail-closed | **OK** |
| **9** Plaćanje samo nakon `Accepted`; reuse Pending preko `GetApprovalUrlAsync`; lock usluge/vremena nakon `Paid`; admin CRUD guard (3 mjesta) | **OK** |
| **10** `GetAvailabilityAsync` (servis + kontroler); create re-validacija: radno vrijeme + `ResolveRoomAsync` + `EndTime` iz usluge | **OK** |
| **11** `RecordStatusChange` (definicija + update + cancel); nema `Completed` prije kraja termina | **OK** |

## Blok 4 — stavke 12–19

| Stavka | Nalaz |
|---|---|
| **12** Codebook kontroleri admin-guarded (6 atributa); delete blokiran dok status koristi zapis | **OK** |
| **13** Desktop doctor `doctorPost`/`doctorIdDelete`; city forma nosi telefon/radno vrijeme/delete | **OK** |
| **14** `password-reset/request` + `/complete`; čuva se samo `CodeHash` | **OK** |
| **15** Login/add-patient koriste `Form` + `validator:`; sirovi `$e` uklonjen iz dodirnutih ekrana (0) | **OK** |
| **16** `MarkRead` nema više GET rutu (0); ostaju POST + PATCH | **OK** |
| **17** Hygiene `EnsureNoEntryForDayAsync` + unique index | **OK** |
| **18** `WeightPersonalViews` uklonjen; ostaje samo `DetailOpened` scoring (`View` se i dalje pohranjuje u `ParseKind`) | **OK** |
| **19** `MapToListResponse` hook; `Product`/`Order`/`User` izostavljaju bajtove + `HasPicture`; `RemoteImage` widget na 5 ekrana | **OK** |

## Zaključak

Statička provjera **nije pronašla nijedan problem** — svaka od 19 stavki ima
konkretnu implementaciju u kodu, potpisi su usklađeni, a ručne migracije se
poklapaju sa `SOHDbContextModelSnapshot.cs`.

**Ovo NE zamjenjuje kompajliranje.** Prije odbrane obavezno lokalno:

```
dotnet build backend/app.sln
dotnet ef migrations add VerifyProbe \
  --project backend/SOH.Services --startup-project backend/SOH.WebAPI
#   → migracija MORA biti prazna (nema zaostalih model promjena); ako jeste, obriši je
flutter analyze          # u mobile/
flutter analyze          # u desktop/
```

Najveći rizik je i dalje isti: sve promjene su verifikovane čitanjem, a ne
kompajlerom, i repo nema build CI koji bi to uhvatio. Prva tri reda iznad su
najvrednija stvar koju treba uraditi.
