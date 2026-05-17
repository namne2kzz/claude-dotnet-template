<#
.SYNOPSIS
  Run code quality checks across backend and frontend.

.DESCRIPTION
  Runs: dotnet build (warnings as errors), dotnet test, ng build, ng lint

.EXAMPLE
  .\check-quality.ps1
  .\check-quality.ps1 -BackendOnly
  .\check-quality.ps1 -FrontendOnly
#>

param(
    [switch]$BackendOnly,
    [switch]$FrontendOnly
)

$failed = @()

if (-not $FrontendOnly) {
    Write-Host "=== Backend Quality Check ===" -ForegroundColor Cyan

    Push-Location "..\..\projects\backend"

    Write-Host "Building (warnings as errors)..." -ForegroundColor Yellow
    dotnet build -warnaserror --configuration Release
    if ($LASTEXITCODE -ne 0) { $failed += "dotnet build" }

    Write-Host "Running tests..." -ForegroundColor Yellow
    dotnet test --configuration Release --collect "XPlat Code Coverage"
    if ($LASTEXITCODE -ne 0) { $failed += "dotnet test" }

    Pop-Location
}

if (-not $BackendOnly) {
    Write-Host "=== Frontend Quality Check ===" -ForegroundColor Cyan

    Push-Location "..\..\projects\frontend"

    Write-Host "TypeScript check..." -ForegroundColor Yellow
    npx tsc --noEmit
    if ($LASTEXITCODE -ne 0) { $failed += "tsc" }

    Write-Host "Linting..." -ForegroundColor Yellow
    ng lint
    if ($LASTEXITCODE -ne 0) { $failed += "ng lint" }

    Write-Host "Production build..." -ForegroundColor Yellow
    ng build --configuration production
    if ($LASTEXITCODE -ne 0) { $failed += "ng build" }

    Write-Host "Tests..." -ForegroundColor Yellow
    ng test --watch=false --browsers=ChromeHeadless
    if ($LASTEXITCODE -ne 0) { $failed += "ng test" }

    Pop-Location
}

Write-Host ""
if ($failed.Count -eq 0) {
    Write-Host "All checks passed!" -ForegroundColor Green
} else {
    Write-Host "FAILED checks:" -ForegroundColor Red
    $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}
