<#
.SYNOPSIS
  Setup local development databases (SQL Server + PostgreSQL + Redis).

.DESCRIPTION
  Uses Docker to spin up SQL Server, PostgreSQL, and Redis for local development.
  Then applies EF Core migrations.

.EXAMPLE
  .\setup-db.ps1
  .\setup-db.ps1 -SkipMigrations
#>

param(
    [switch]$SkipMigrations,
    [switch]$ResetData
)

Write-Host "Setting up development databases..." -ForegroundColor Cyan

# SQL Server
Write-Host "Starting SQL Server..." -ForegroundColor Yellow
docker run -d `
  --name dev-sqlserver `
  -e "ACCEPT_EULA=Y" `
  -e "SA_PASSWORD=Dev@Password123!" `
  -p 1433:1433 `
  mcr.microsoft.com/mssql/server:2022-latest

# PostgreSQL
Write-Host "Starting PostgreSQL..." -ForegroundColor Yellow
docker run -d `
  --name dev-postgres `
  -e POSTGRES_PASSWORD=devpassword `
  -e POSTGRES_DB=devdb `
  -p 5432:5432 `
  postgres:16-alpine

# Redis
Write-Host "Starting Redis..." -ForegroundColor Yellow
docker run -d `
  --name dev-redis `
  -p 6379:6379 `
  redis:7-alpine

Write-Host "Waiting for databases to be ready (10s)..." -ForegroundColor Gray
Start-Sleep -Seconds 10

if (-not $SkipMigrations) {
    Write-Host "Applying EF Core migrations..." -ForegroundColor Yellow
    Push-Location "..\..\projects\backend"

    dotnet ef database update `
      --project src\Infrastructure `
      --startup-project src\WebApi `
      --connection "Server=localhost,1433;Database=DevDb;User=sa;Password=Dev@Password123!;TrustServerCertificate=true"

    Pop-Location
}

Write-Host ""
Write-Host "Databases ready!" -ForegroundColor Green
Write-Host "SQL Server: localhost,1433 / sa / Dev@Password123!"
Write-Host "PostgreSQL: localhost:5432 / postgres / devpassword / devdb"
Write-Host "Redis:      localhost:6379"
