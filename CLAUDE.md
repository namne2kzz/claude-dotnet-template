# Full-Stack .NET + Angular + DB — Claude Instructions

## Stack

| Layer | Tech |
|-------|------|
| Backend | .NET 10, C# 14, Clean Architecture, DDD, CQRS, MediatR, FluentValidation |
| Frontend | Angular v20+, Signals, Standalone Components, RxJS |
| Database | SQL Server + PostgreSQL (EF Core 10), Redis (StackExchange.Redis) |
| Cloud | Azure: AKS, App Service, Service Bus, Key Vault, Application Insights |
| DevOps | Azure DevOps, GitHub Actions, Docker, Kubernetes |

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

## Architecture Rules

### Clean Architecture — Layer Dependencies
| Layer | May depend on |
|-------|--------------|
| Domain | Nothing |
| Application | Domain only |
| Infrastructure | Application + Domain |
| WebApi | Application only |

Domain logic never in Infrastructure or WebApi. Violations are blocking.

### CQRS
- Commands mutate state, return `Result<T>` — never return entity
- Queries are read-only — `AsNoTracking()` always, project with `Select()`, never load full entity
- One handler = one responsibility (SRP)

### DDD
- Aggregate roots own their consistency boundary — no direct cross-aggregate references
- Domain events (`IDomainEvent`) for inter-aggregate communication
- Value objects are immutable — no public setters
- Ubiquitous language in all naming

---

## Angular Rules

- `standalone: true` on every component — no NgModules
- Signals for reactive state — no BehaviorSubject in components
- `@if` / `@for` / `@defer` — never `*ngIf` / `*ngFor`
- `inject()` for DI — never constructor injection
- `track` expression required in every `@for`
- HTTP calls in services only — never directly in components
- `OnPush` change detection on all display/presentational components
- `toSignal()` or `takeUntilDestroyed(destroyRef)` on every `subscribe()` — no leaks

---

## Non-negotiable Engineering Rules

### Memory Management
**.NET**
- `using` / `await using` for every `IDisposable` / `IAsyncDisposable`
- `DbContext` must be Scoped — never Singleton; use `IDbContextFactory<T>` in background services
- `HttpClient` via `IHttpClientFactory` — never `new HttpClient()`

**Angular**
- Prefer `toSignal()` — auto-cleanup, no manual unsubscribe needed
- Every manual `subscribe()` must use `takeUntilDestroyed(destroyRef)`
- `Subject` / `BehaviorSubject` must call `.complete()` in `ngOnDestroy`
- Clear large object references from long-lived services on logout/reset

### Async (.NET)
- `async/await` everywhere — never `.Result`, `.Wait()`, or `.GetAwaiter().GetResult()`
- `CancellationToken ct = default` on every async method, passed through all layers
- No `Task.Run()` in controllers or handlers

### Security
- Secrets in Azure Key Vault — never in `appsettings.json` or source code
- `[Authorize]` on every non-public endpoint
- FluentValidation on every Command and Query (Application layer)
- Angular: no tokens or sensitive data in `localStorage` — use `sessionStorage` or in-memory

### DI & SOLID
- Depend on abstractions (`IRepository<T>`, `ICacheService`) — never concrete types in business code
- Never `new ServiceImpl()` in business logic — always inject
- Lifetimes: Singleton for stateless infra, Scoped for DbContext, Transient for lightweight
- Strategy pattern for branching on type — no if/else chains over implementation

### EF Core
- `AsNoTracking()` on all read queries
- Project with `Select()` — never load full entity for reads
- `IEntityTypeConfiguration<T>` for mapping — no DataAnnotations on domain entities
- Redis TTL: reference data 1h, user-specific 5min, ephemeral 30s

---

## Code Documentation (Strict — No Exceptions)

Every public method must have a doc comment.

```csharp
/// <summary>Retrieves order by ID, or null if not found.</summary>
/// <param name="orderId">The order unique identifier.</param>
/// <param name="ct">Cancellation token.</param>
/// <returns>OrderDto if found; null otherwise.</returns>
public async Task<OrderDto?> GetByIdAsync(Guid orderId, CancellationToken ct = default)
```

```typescript
/**
 * Loads paginated products matching the given filters.
 * @param filters Filter criteria to apply.
 * @returns Observable emitting the paginated result.
 */
loadProducts(filters: ProductFilters): Observable<PagedResult<Product>>
```

Rules: one-line `<summary>`, every `<param>` including `CancellationToken`, `<returns>` with null cases. Skip only for `void`/`Promise<void>` and self-explanatory property getters.

---

## File Conventions (Strict)

### Angular — 4 files per component, always
```
feature.component.ts        ← class only (templateUrl + styleUrl refs)
feature.component.html      ← template
feature.component.scss      ← styles
feature.component.spec.ts   ← Jasmine tests
```
Never `template: \`...\`` inline. Interfaces/types always in `models/*.model.ts` — never inside service or component files.

### .NET — Separate request/response
- Request records → `WebApi/{Feature}/Requests/`
- Response DTOs → `Application/{Feature}/DTOs/`
- Never define records/DTOs inside a Controller file

---

## Review Checklist

**Backend:** layer deps correct · domain logic not in infra/api · async+CT correct · AsNoTracking on reads · FluentValidation on all commands · no sensitive data logged · unit tests cover happy/notfound/validation/exception · Verify() on side effects

**Angular:** standalone + imports correct · signals not BehaviorSubject · @if/@for/@defer · inject() · track in @for · OnPush on display components · no subscribe leaks · detectChanges() after signal updates in tests · httpMock.verify() in afterEach

**Database:** indexes match query patterns · migrations have Down() · no raw SQL without params · Redis keys: `{service}:{entity}:{id}`

---

## Skills Reference

Detailed patterns and code templates in `.claude/skills/`:

| Area | Skills |
|------|--------|
| Backend | `generate-dotnet` · `clean-architecture` · `ddd-cqrs` · `unit-testing` · `testcontainers` · `aspire-orchestration` · `opentelemetry` · `resilience-patterns` · `snapshot-testing` · `api-versioning` |
| Frontend | `generate-angular` · `angular-signals` · `angular-rxjs` · `unit-testing-angular` |
| Database | `efcore-sqlserver` · `efcore-postgresql` · `redis-cache` · `migrations` · `query-optimization` |

Agents: `dotnet-coder` · `angular-coder` · `reviewer` · `architect` · `db-optimizer` · `security-auditor` · `build-error-resolver`

Workflows: `build-feature` · `fix-bug` · `code-review` · `deploy-to-azure` · `tdd` · `security-scan` · `health-check`
