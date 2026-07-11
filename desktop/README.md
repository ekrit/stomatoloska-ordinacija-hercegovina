# Dental Clinic Herzegovina - Desktop (Staff)

Flutter Windows app for clinic administrators and doctors. Pairs with the .NET
backend in [`../backend/`](../backend/) and the patient mobile client in
[`../mobile/`](../mobile/).

Desktop is staff-only. Patient accounts are rejected at the login screen with
a message pointing them to the mobile app.

## Build

```powershell
flutter pub get
flutter build windows --release
```

The release binary lives under
`build/windows/x64/runner/Release/desktop.exe`.

## Run against a running API

```powershell
# Backend running locally on http://localhost:5130 (default)
flutter run -d windows --dart-define=API_BASE_URL=http://127.0.0.1:5130
```

`API_BASE_URL` defaults to `http://127.0.0.1:5130` on Windows; override via
`--dart-define=API_BASE_URL=...` to point at a remote backend.

## Regenerate the API client (`packages/soh_api`)

The generated Dart client is committed; the downloaded `openapi.json` is
not. After backend changes, regenerate against the running API (needs Java
for the generator; pass `--additional-properties=pubName=soh_api`):

```powershell
# From repo root, with the backend running on http://localhost:5130
Invoke-WebRequest -Uri http://localhost:5130/swagger/v1/swagger.json -OutFile desktop/openapi.json
cd desktop
dart run openapi_generator_cli generate -i openapi.json -g dart -o packages/soh_api --additional-properties=pubName=soh_api
```
