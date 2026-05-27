Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$webApiDir = Join-Path $repoRoot "backend\SOH.WebAPI"

if (-not (Test-Path $webApiDir)) {
  throw "SOH.WebAPI not found at: $webApiDir"
}

# Development API on same port as Flutter app_config (5130).
$env:ASPNETCORE_ENVIRONMENT = "Development"

Push-Location $webApiDir
try {
  dotnet --version | Out-Host
  Write-Host "Starting SOH.WebAPI (database: appsettings.json DefaultConnection; migrations run on startup)."
  Write-Host "Swagger: http://localhost:5130/swagger"
  dotnet run --launch-profile http
}
finally {
  Pop-Location
}
