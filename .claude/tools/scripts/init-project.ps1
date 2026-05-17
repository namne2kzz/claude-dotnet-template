<#
.SYNOPSIS
  Initialize a new project from this template.

.DESCRIPTION
  Sets up a new full-stack .NET + Angular project with:
  - .NET backend (Clean Architecture)
  - Angular 20 frontend
  - SQL Server + PostgreSQL (EF Core)
  - Redis cache

.PARAMETER ProjectName
  Name of the new project (PascalCase)

.PARAMETER OutputPath
  Where to create the project folder

.EXAMPLE
  .\init-project.ps1 -ProjectName "MyApp" -OutputPath "C:\Projects"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "."
)

$projectPath = Join-Path $OutputPath $ProjectName

Write-Host "Creating project: $ProjectName at $projectPath" -ForegroundColor Cyan

# Create backend structure
$backendDirs = @(
    "src\$ProjectName.Domain\Entities",
    "src\$ProjectName.Domain\Events",
    "src\$ProjectName.Domain\ValueObjects",
    "src\$ProjectName.Domain\Interfaces",
    "src\$ProjectName.Application\Commands",
    "src\$ProjectName.Application\Queries",
    "src\$ProjectName.Application\DTOs",
    "src\$ProjectName.Application\Validators",
    "src\$ProjectName.Application\Behaviors",
    "src\$ProjectName.Infrastructure\Persistence",
    "src\$ProjectName.Infrastructure\Repositories",
    "src\$ProjectName.Infrastructure\Caching",
    "src\$ProjectName.WebApi\Controllers",
    "src\$ProjectName.WebApi\Middleware",
    "tests\$ProjectName.Unit",
    "tests\$ProjectName.Integration"
)

$backendPath = Join-Path $projectPath "backend"
foreach ($dir in $backendDirs) {
    New-Item -ItemType Directory -Path (Join-Path $backendPath $dir) -Force | Out-Null
}

# Create frontend structure
$frontendDirs = @(
    "src\app\core\auth",
    "src\app\core\interceptors",
    "src\app\core\guards",
    "src\app\shared\components",
    "src\app\shared\pipes",
    "src\app\shared\directives",
    "src\app\features",
    "src\app\layouts",
    "src\environments"
)

$frontendPath = Join-Path $projectPath "frontend"
foreach ($dir in $frontendDirs) {
    New-Item -ItemType Directory -Path (Join-Path $frontendPath $dir) -Force | Out-Null
}

Write-Host "Project structure created!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. cd $projectPath/backend"
Write-Host "  2. dotnet new sln -n $ProjectName"
Write-Host "  3. Create .NET projects per domain"
Write-Host "  4. cd $projectPath/frontend"
Write-Host "  5. ng new $ProjectName --standalone --routing --style=scss"
Write-Host "  6. Configure appsettings.json with connection strings"
Write-Host "  7. dotnet ef migrations add InitialCreate"
