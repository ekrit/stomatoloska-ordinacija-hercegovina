# Dental Clinic Herzegovina - Mobile (Patient)

Flutter Android app for clinic patients. Pairs with the .NET backend in
[`../backend/`](../backend/) and the staff desktop client in
[`../desktop/`](../desktop/).

Mobile is patient-only. Administrator and Doctor accounts are rejected at the
login screen with a message pointing them to the desktop app.

## Build

```powershell
flutter pub get
flutter build apk --release
```

The release APK lives under
`build/app/outputs/flutter-apk/app-release.apk`.

## Run against a running API

```powershell
# Android emulator (default; API on host at port 5130)
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:5130

# Physical Android device (replace with the host LAN IP)
flutter run -d <device-id> --dart-define=API_BASE_URL=http://192.168.1.10:5130
```

The default API base URL for Android is `http://10.0.2.2:5130`; override with
`--dart-define=API_BASE_URL=...` when running on real hardware or against a
remote backend.

## Regenerate the API client (`packages/soh_api`)

The generated Dart client is committed; the downloaded `openapi.json` is
not. After backend changes, regenerate against the running API (needs Java
for the generator; pass `--additional-properties=pubName=soh_api`):

```powershell
# From repo root, with the backend running on http://localhost:5130
Invoke-WebRequest -Uri http://localhost:5130/swagger/v1/swagger.json -OutFile mobile/openapi.json
cd mobile
dart run openapi_generator_cli generate -i openapi.json -g dart -o packages/soh_api --additional-properties=pubName=soh_api
```
