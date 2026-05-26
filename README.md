# Stomatološka ordinacija Hercegovina

This repository contains the seminar project **"Stomatološka ordinacija
Hercegovina"**, an application that simulates the management and online
presence of a dental clinic.

The project is developed for academic purposes and includes:
- Presentation of dental services
- Patient information management
- Appointment scheduling (request, accept, complete, review, cancel)
- Hybrid product recommendations (content + collaborative + behavioral)
- In-app notifications via SignalR
- Admin reporting (PDF)
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
