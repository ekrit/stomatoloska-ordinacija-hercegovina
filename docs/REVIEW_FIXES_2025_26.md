# Dorade po review-u (akademska 2025/26)

Radni plan za 19 komentara iz review-a (Adil Joldić). Ovaj dokument je
**živi checklist** — svaka stavka se čekira tek kada je promjena commitana.

> Napomena o okruženju: u ovoj radnoj sesiji nema `dotnet` SDK-a ni `flutter`
> alata (egress proxy blokira instalaciju), pa se promjene verifikuju čitanjem
> koda, a ne kompajliranjem. Prije odbrane obavezno lokalno pokrenuti
> `dotnet build` + `flutter analyze`.

## Redoslijed rada (faze)

Faze su poredane po zavisnostima: sigurnosni core prvi, jer o njemu ovise
kasnije poslovne provjere.

| Faza | Stavke | Tema |
|---|---|---|
| A | 4, 1, 2, 3 | Autentikacija i autorizacija po zapisu |
| B | 5, 6 | Registracija i profil (jedan tok, jedan source-of-truth) |
| C | 7, 8, 9 | Plaćanje: valuta, webhook, state machine |
| D | 10, 11 | Dostupnost termina i audit statusa |
| E | 12, 13 | Šifarnici i desktop administracija |
| F | 14, 15 | Mobile: reset lozinke i validacija |
| G | 16, 17, 18, 19 | HTTP semantika, invarijante, recommender, DTO-i |

Sve izmjene sheme idu kroz **ručno pisane EF migracije** (nema `dotnet ef`
u okruženju), grupisane da se `SOHDbContextModelSnapshot.cs` dira što rjeđe.

> **Ručno pisane migracije — šta provjeriti lokalno:** migracija
> `20260830050000_PaymentCurrencyAndSettlement` nema prateći `.Designer.cs`
> (generator nije dostupan), pa su `[DbContext]` i `[Migration]` atributi
> stavljeni direktno na klasu — `Database.Migrate()` je zbog toga vidi
> normalno. `SOHDbContextModelSnapshot.cs` je ažuriran ručno. Prije sljedećeg
> `dotnet ef migrations add` provjeriti da diff ne prijavi zaostale promjene.

---

## Stavke

### Faza A — autorizacija

- [x] **4. Deaktivirani korisnik se i dalje može prijaviti.**
  `UserService.AuthenticateAsync()` ne provjerava `IsActive`.
  *Rješenje:* odbiti login neaktivnom korisniku uz jasnu poruku, prije
  izdavanja JWT-a.

- [x] **1. Autorizacija po konkretnom zapisu (IDOR).**
  `BaseController.GetById(int id)` vraća zapis samo po ID-u; kontroleri sužavaju
  samo list endpoint. Najosjetljiviji je `PaymentResponse` (iznos, status,
  PayPal reference).
  *Rješenje:* serverska provjera vlasništva na svakom user-data `GetById`
  (Appointment, Patient, Order, HygieneTracker, Review, Payment,
  MedicalRecord), po roli iz JWT-a.

- [x] **2. Klijentski `PatientId` na write operacijama.**
  `AppointmentUpsertRequest`, `OrderUpsertRequest`, `HygieneTrackerUpsertRequest`
  nose `PatientId` koji se ne veže za `ClaimTypes.NameIdentifier`.
  *Rješenje:* za Patient rolu identitet uvijek iz JWT-a; kod update-a provjera
  vlasništva prije izmjene.

- [x] **3. Prava doktora nad terminima i nalazima.**
  `AppointmentController.Cancel()` tretira doktora kao privilegovanog bez
  provjere da je termin njegov; `Update()` zaključava `DoctorId` ali ne
  `PatientId`; `MedicalRecordService` ne provjerava da je doktor doktor tog
  appointmenta; `AppointmentId` nalaza je slobodno promjenjiv.
  *Rješenje:* doktor smije samo svoje termine i nalaze svojih termina;
  `PatientId` zaključati na pacijenta postojećeg termina; `AppointmentId`
  nalaza nepromjenjiv kroz obični update.

### Faza B — registracija i profil

- [x] **5. Jedan konzistentan tok registracije/kreiranja pacijenta.**
  `Register()` šalje `dateOfBirth: null` → upisuje se datum registracije;
  `complete_profile_screen.dart` zove admin-only `POST /Patient`;
  `admin_add_patient_screen.dart` duplo kreira Patient.
  *Rješenje:* jedan atomaran tok koji kreira User + Patient sa stvarnim
  datumom rođenja; ukloniti/prilagoditi `CompleteProfile`.

- [x] **6. Duplirani podaci profila između `User`, `Patient`, `Doctor`.**
  Mobile mijenja samo `/Users/{id}`, a projekcije čitaju iz `Patient`.
  *Rješenje:* sinhronizacija povezanog Patient/Doctor zapisa u istoj poslovnoj
  operaciji; kod promjene role ne dodjeljivati Doctor/Patient bez domenskog
  profila.

### Faza C — plaćanje

- [x] **7. PayPal valuta nije usklađena s cijenama (KM vs EUR).**
  *Rješenje:* jedna definisana valuta sistema; ako PayPal mora u EUR, serverska
  konverzija po jasnom pravilu uz čuvanje naplaćenog iznosa i valute.

- [x] **8. Webhook verifikacija mora biti fail-closed.**
  `VerifyWebhookAsync()` vraća `true` kada konfiguracija nedostaje.
  *Rješenje:* bez konfiguracije → odbiti događaj; mock samo iza eksplicitne
  development-only opcije.

- [x] **9. Payment state nije vezan za stanje termina.**
  Postojeći `Pending` se prepisuje; ne provjerava se `Appointment.Status`;
  moguće `Paid` + `Declined`; nakon plaćanja usluga/vrijeme ostaju promjenjivi;
  admin raw CRUD može proizvoljno postaviti `Paid`/`TransactionRef`.
  *Rješenje:* reuse/blokada postojećeg Pending-a, plaćanje samo nakon
  `Accepted`, zaključavanje komercijalnih polja nakon `Paid`, ograničen admin
  CRUD.

### Faza D — dostupnost i audit

- [x] **10. Slobodni termini se računaju na klijentu.**
  Pacijent ne vidi tuđa zauzeća; fiksnih 30 min umjesto trajanja usluge; mobile
  sam bira prostoriju i pada na `rooms.first`; `EndTime` dolazi od klijenta;
  radno vrijeme samo u client konfiguraciji.
  *Rješenje:* serverska availability operacija (doktor + datum + usluga →
  stvarni slotovi) uz trajanje usluge, `Room.IsAvailable` i radno vrijeme;
  backend pri kreiranju ponovo potvrđuje ista pravila.

- [x] **11. Audit i razlozi promjene statusa.**
  `Cancel(int id)` nema razlog; `DoctorNote` se koristi za tri različite stvari;
  moguće `Accepted -> Completed` prije kraja termina.
  *Rješenje:* odvojiti `PatientComplaint` od `DeclineReason`/`DoctorNote`,
  uvesti razlog otkazivanja i audit (ko/kad/iz kojeg u koji status/zašto);
  spriječiti prerano `Completed`.

### Faza E — šifarnici i desktop administracija

- [ ] **12. CRUD za referentne podatke.**
  `AppointmentStatus` i `PaymentStatus` su samo enum-i; `City` ima API CRUD ali
  desktop nema kompletan delete tok.
  *Rješenje:* administratorski CRUD (GET/POST/PUT/DELETE) za sve šifarnike koje
  projekat koristi, uz odgovarajuće desktop ekrane.

- [ ] **13. Nepotpuna desktop administracija.**
  Nema dodavanja/brisanja doktora; `admin_city_edit_screen.dart` šalje samo
  `Name` iako lokacija ima adresu, telefon, email i radno vrijeme; nema
  kompletan delete tok za lokacije.
  *Rješenje:* dovršiti create/update/delete tokove i formu lokacije.

### Faza F — mobile

- [ ] **14. Nedostaje "forgot password" tok.**
  Postoji samo `change-password` za prijavljenog korisnika.
  *Rješenje:* zahtjev za reset → jednokratni token/kod → nova lozinka nakon
  serverske provjere. Postojeći change-password ostaje.

- [ ] **15. Nedosljedna validacija i poruke greške.**
  `login_screen.dart` i `admin_add_patient_screen.dart` koriste obične
  `TextField`; ponegdje se prikazuje sirovi `$e`; `[Required]` na non-nullable
  `int` ne sprječava 0.
  *Rješenje:* `Form` + validatori uz kontrole, kontrolisane poruke greške,
  range/domain validatori za FK ID-eve, rating i `BrushesCount`.

### Faza G — ostalo

- [ ] **16. GET mijenja stanje notifikacije.**
  `MarkRead(int id)` je izložen i preko GET-a.
  *Rješenje:* jedan write endpoint (PATCH/POST `/notifications/{id}/read`).

- [ ] **17. Hygiene tracker bez dnevnog invarijanta.**
  Nema provjere jednog zapisa po pacijentu po danu; `BrushesCount` bez opsega.
  *Rješenje:* unique constraint + servisna provjera, validacija opsega.

- [ ] **18. Recommender signali nisu usklađeni sa scoringom.**
  `View` ima težinu, ali nema produkcijskog poziva koji ga zapisuje.
  *Rješenje:* stvarno zapisati `View` na korisničkom događaju, ili ukloniti
  signal/težinu i uskladiti dokumentaciju.

- [ ] **19. List endpointi vraćaju pune slike.**
  `UserResponse.Picture`, `ProductResponse.Picture`, `OrderResponse.ProductPicture`
  su `byte[]` u list servisima, uz limit od ~2 MB po slici.
  *Rješenje:* razdvojiti list i detail DTO-e; lista bez pune slike, puna slika
  na posebnom details/image endpointu.

---

## Dnevnik rada

| Datum | Stavka | Commit | Napomena |
|---|---|---|---|
| 2026-08-30 | — | plan | Analiziran review i codebase, napravljen plan |
| 2026-08-30 | 4 | faza A | `AuthenticateAsync` odbija neaktivnog korisnika |
| 2026-08-30 | 1 | faza A | `IRecordOwnership` + `EnsureCallerMayAccessAsync`, provjera vlasništva na svakom user-data `GetById` |
| 2026-08-30 | 2 | faza A | `PatientId` se za Patient rolu uzima iz JWT-a (termin, narudžba, higijena); ownership prije update-a |
| 2026-08-30 | 3 | faza A | `AppointmentActor` umjesto `isPrivileged`; `PatientId` termina zaključan; doktor vodi nalaze samo svojih termina; `AppointmentId` nalaza nepromjenjiv |
| 2026-08-30 | 5 | faza B | `DateOfBirth` obavezan pri registraciji; jedan atomaran tok (User+Patient); uklonjen `CompleteProfile`; desktop admin više ne kreira Patient dvaput |
| 2026-08-30 | 6 | faza B | `SyncDomainProfilesAsync` — User je source-of-truth za ime/telefon, Patient/Doctor se sinhronizuju u istoj operaciji; uloga se ne dodjeljuje bez domenskog profila |
| 2026-08-30 | 7 | faza C | `MoneyPolicy`: BAM je valuta sistema, PayPal se naplaćuje u EUR po fiksnom kursu 1 EUR = 1.95583 KM; `Payment` čuva i naplaćeni iznos/valutu |
| 2026-08-30 | 8 | faza C | `VerifyWebhookAsync` fail-closed; mock samo uz eksplicitni `PAYPAL__ALLOW_UNVERIFIED_WEBHOOKS=true` |
| 2026-08-30 | 10 | faza D | `GET /Appointment/availability` računa stvarne slotove (trajanje usluge, slobodan doktor i prostorija, radno vrijeme); `EndTime` i prostorija se izvode serverski; klijent samo prikazuje |
| 2026-08-30 | 11 | faza D | `PatientComplaint`/`DeclineReason`/`CancelReason` odvojeni; obavezan razlog otkazivanja i odbijanja; `AppointmentStatusHistory` (ko/kad/iz→u/zašto); nema `Completed` prije kraja termina |
| 2026-08-30 | 9 | faza C | Plaćanje tek nakon `Accepted`; postojeći Pending se reuse-uje preko `GetApprovalUrlAsync`; usluga/vrijeme zaključani nakon `Paid`; admin CRUD ne može postaviti `Paid`/`TransactionRef` |
