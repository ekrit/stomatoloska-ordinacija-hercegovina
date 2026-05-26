Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$backendDir = Join-Path $repoRoot "backend"

Write-Host "Starting backend via Docker Compose..."

if (-not (Test-Path $backendDir)) {
  throw "backend/ directory not found at: $backendDir"
}

Push-Location $backendDir
try {
  if (-not (Test-Path ".\.env")) {
    if (Test-Path ".\.env.example") {
      Copy-Item ".\.env.example" ".\.env" -Force
      Write-Host "Created backend/.env from backend/.env.example (edit passwords as needed)."
    } else {
      Write-Warning "No backend/.env or backend/.env.example found. Docker Compose may fail if env vars are missing."
    }
  }

  docker --version | Out-Host
  docker compose version | Out-Host

  docker compose up --build
}
finally {
  Pop-Location
}
