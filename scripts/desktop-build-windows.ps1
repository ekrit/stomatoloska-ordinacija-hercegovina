Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$desktopDir = Join-Path $repoRoot "desktop"

Write-Host "Building Flutter Windows desktop app (admin + doctor)..."

if (-not (Test-Path $desktopDir)) {
  throw "desktop/ directory not found at: $desktopDir"
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

Push-Location $desktopDir
try {
  flutter --version
  flutter doctor -v

  flutter pub get
  flutter build windows --release

  Write-Host ""
  Write-Host "Build output:"
  Write-Host (Join-Path $desktopDir "build\windows\x64\runner\Release")
}
finally {
  Pop-Location
}
