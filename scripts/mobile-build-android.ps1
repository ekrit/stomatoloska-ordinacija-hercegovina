Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$mobileDir = Join-Path $repoRoot "mobile"

Write-Host "Building Flutter Android patient app..."

if (-not (Test-Path $mobileDir)) {
  throw "mobile/ directory not found at: $mobileDir"
}

function Assert-Command($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    throw @"
Missing required command: $name

Install Flutter and ensure it's on PATH, then restart your terminal:
- https://docs.flutter.dev/get-started/install/windows

After install, verify:
  flutter --version
  flutter doctor -v
"@
  }
}

Assert-Command "flutter"

Push-Location $mobileDir
try {
  flutter --version
  flutter doctor -v

  flutter pub get
  flutter build apk --release

  Write-Host ""
  Write-Host "Build output:"
  Write-Host (Join-Path $mobileDir "build\app\outputs\flutter-apk\app-release.apk")
}
finally {
  Pop-Location
}
