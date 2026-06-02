# Stomatološka ordinacija Hercegovina

This repository contains the seminar project **"Stomatološka ordinacija
Hercegovina"**, an application that simulates the management and online
presence of a dental clinic.

The project is developed for academic purposes and includes:
- Presentation of dental services
- Patient information management
- Appointment scheduling (request, accept, complete, review, cancel)
- In-app PayPal (sandbox) payment for appointments, with refund-while-not-completed
- Hybrid product recommendations (content + collaborative + behavioral)
- In-app notifications via SignalR
- Admin reporting (PDF + print)
- Patient mobile app and staff desktop app

**Technologies:**
- Backend: **C# (.NET 8), Docker, RabbitMQ, SQL Server**
- Frontend: **Flutter** (Android for patients, Windows for staff)

> Seminar project – educational use only.

## Repository structure

- `mobile/` Flutter Android app for patients (only Patient accounts can sign in)
- `desktop/` Flutter Windows app for clinic staff (only Administrator and Doctor accounts can sign in)
- `backend/` .NET REST API, RabbitMQ subscriber, and Docker files
- `docs/` command references (Flutter, Docker, C#)
- `scripts/` PowerShell helper scripts

## Build & run (Windows)

### 1. Backend (API + SQL Server + RabbitMQ via Docker)

Prereqs:
- Docker Desktop
- .NET SDK 8+

Copy [`backend/.env.example`](backend/.env.example) to `backend/.env` and fill in
at minimum `SQL__PASSWORD`, `RABBITMQ__*`, and `JwtSettings__SecretKey` (32+
random chars). SMTP credentials are only needed if you want the appointment
reminder worker to send real emails; leave blank to disable it. The API and
the subscriber both call `DotNetEnv` at startup, so the same `.env` file is
also picked up by `dotnet run` outside Docker.

To enable appointment payments, set `PAYPAL__CLIENT_ID` and
`PAYPAL__CLIENT_SECRET` from a PayPal **Sandbox** REST app
(<https://developer.paypal.com>); `PAYPAL__BASE_URL` defaults to the sandbox.
Leave them blank to disable payments (the payment endpoints then return a
clear "PayPal is not configured" message). The amount is always taken from the
service catalog server-side — the client never sends a price.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\backend-up.ps1
```

API is exposed on `http://localhost:5130` (see [`backend/docker-compose.yml`](backend/docker-compose.yml)).

### 2. Mobile patient app (Flutter Android)

Prereqs:
- Flutter SDK on PATH
- Android Studio (emulator)

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\mobile-build-android.ps1
```

Release APK: `mobile/build/app/outputs/flutter-apk/app-release.apk`.

### 3. Desktop staff app (Flutter Windows)

Prereqs:
- Flutter SDK on PATH
- Visual Studio (Desktop development with C++)

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\desktop-build-windows.ps1
```

Release binary: `desktop/build/windows/x64/runner/Release/desktop.exe`.

See [`mobile/README.md`](mobile/README.md) and [`desktop/README.md`](desktop/README.md) for the per-project details and the `--dart-define=API_BASE_URL=...` examples.

## Seeded credentials (development)

The first time the API runs against an empty database, EF Core migrations
seed the records below (defined in
[`backend/SOH.Services/Database/DataSeeder.cs`](backend/SOH.Services/Database/DataSeeder.cs)).
All seeded accounts share the same dev password.

| Role          | Username | Password       | Lives in     |
| ------------- | -------- | -------------- | ------------ |
| Administrator | `admin`  | `SohDev2026!`  | Desktop      |
| Doctor        | `admin2` | `SohDev2026!`  | Desktop      |
| Patient       | `user`   | `SohDev2026!`  | Mobile       |
| Patient       | `user2`  | `SohDev2026!`  | Mobile       |

The desktop app rejects Patient logins ("This account is for patients...");
the mobile app rejects Administrator and Doctor logins. Use the right
account in the right client, or both will refuse to sign you in.

## Documentation index

- [`docs/recommender-dokumentacija.md`](docs/recommender-dokumentacija.md) - how the patient product recommender scores items and explains itself.
- [`docs/plan-seminar-vs-solution-gap.md`](docs/plan-seminar-vs-solution-gap.md) - rubric/requirements coverage and gap report.
- [`docs/Docker Commands.txt`](docs/Docker%20Commands.txt) / [`docs/Flutter Commands.txt`](docs/Flutter%20Commands.txt) / [`docs/C# Commands.txt`](docs/C%23%20Commands.txt) - command references.
- [`backend/.env.example`](backend/.env.example) - required and optional environment variables.
