# Full-Stack .NET + Angular + DB — Claude Instructions

## Stack

| Layer | Tech |
|-------|------|
| Backend | .NET 10, C# 14, Clean Architecture, DDD, CQRS, MediatR, FluentValidation |
| Frontend | Angular v20+, Signals, Standalone Components, RxJS |
| Database | SQL Server + PostgreSQL (EF Core 10), Redis (StackExchange.Redis) |
| Cloud | Azure: AKS, App Service, Service Bus, Key Vault, Application Insights |
| DevOps | Azure DevOps, GitHub Actions, Docker, Kubernetes |

---

## Project Structure

```
src/
├── Domain/           # Entities, Value Objects, Domain Events, Interfaces
├── Application/      # CQRS Handlers, DTOs, Validators (MediatR)
├── Infrastructure/   # EF Core, Redis, external HTTP clients
└── WebApi/           # Controllers, Middleware, DI setup
tests/
├── Unit/             # xUnit + Moq + FluentAssertions
└── Integration/      # Testcontainers — real DB
frontend/src/app/
├── core/             # Auth, interceptors, guards
├── shared/           # Reusable components, pipes, directives
├── features/         # Feature folders (standalone)
└── layouts/
```

---

## Hard Constraints

### Clean Architecture — layer dependencies (never violate)
| Layer | May depend on |
|-------|--------------|
| Domain | Nothing |
| Application | Domain only |
| Infrastructure | Application + Domain |
| WebApi | Application only |

### File conventions
- Angular component = 4 files always: `.ts` / `.html` / `.scss` / `.spec.ts` — never inline template
- Angular interfaces/types → `models/*.model.ts` — never inside component or service files
- .NET request records → `WebApi/{Feature}/Requests/` — never inside Controller file
- .NET response DTOs → `Application/{Feature}/DTOs/` — never inside Controller file

### Code documentation — every public method, no exceptions
```csharp
/// <summary>One-line description.</summary>
/// <param name="ct">Cancellation token.</param>
/// <returns>OrderDto if found; null otherwise.</returns>
```
```typescript
/** One-line description. @param id Entity id. @returns Observable or null. */
```

---

## Automatic Workflow

Khi nhận bất kỳ yêu cầu code nào, hỏi trước:

> "Use auto agent? (yes / no)"

- **yes** → đọc `.claude/.claude/agents/auto.md` và follow toàn bộ flow trong đó
- **no** → respond bình thường, không attach gì thêm

---

## Skills Reference

Detailed patterns and code templates in `.claude/.claude/skills/`:

| Area | Skills |
|------|--------|
| Backend | `generate-dotnet` · `clean-architecture` · `ddd-cqrs` · `unit-testing` · `testcontainers` · `aspire-orchestration` · `opentelemetry` · `resilience-patterns` · `snapshot-testing` · `api-versioning` |
| Frontend | `generate-angular` · `angular-signals` · `angular-rxjs` · `unit-testing-angular` |
| Database | `efcore-sqlserver` · `efcore-postgresql` · `redis-cache` · `migrations` · `query-optimization` |

Agents: `auto` · `dotnet-coder` · `angular-coder` · `reviewer` · `architect` · `db-optimizer` · `security-auditor` · `build-error-resolver`

Workflows: `build-feature` · `fix-bug` · `code-review` · `deploy-to-azure` · `tdd` · `security-scan` · `health-check`
