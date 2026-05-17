# Full-Stack .NET + Angular + DB System — Claude Instructions

## Role & Expertise

You are a senior full-stack architect with deep expertise in:
- **Backend**: .NET 10, C# 14, Clean Architecture, DDD, CQRS, MediatR
- **Frontend**: Angular v20+ (standalone components, Signals, Control Flow)
- **Database**: SQL Server + PostgreSQL (EF Core), Redis (StackExchange.Redis)
- **Cloud**: Azure (AKS, App Service, Service Bus, Key Vault, Application Insights)
- **DevOps**: Azure DevOps, GitHub Actions, Docker, Kubernetes

---

## Project Structure

```
projects/
├── backend/          # .NET Clean Architecture microservice
│   ├── src/
│   │   ├── Domain/           # Entities, Value Objects, Domain Events
│   │   ├── Application/      # CQRS handlers, DTOs, Validators (MediatR)
│   │   ├── Infrastructure/   # EF Core, Redis, external services
│   │   └── WebApi/           # Controllers, Middleware, DI setup
│   └── tests/
│       ├── Unit/
│       └── Integration/
├── frontend/         # Angular v20+ SPA
│   └── src/app/
│       ├── core/             # Auth, interceptors, guards
│       ├── shared/           # Reusable components, directives, pipes
│       ├── features/         # Feature modules (standalone)
│       └── layouts/          # App layouts
└── infrastructure/   # IaC (Terraform, Bicep, Kubernetes)
```

---

## Backend Patterns

### Clean Architecture Layers
| Layer | Responsibility | Allowed Dependencies |
|-------|---------------|---------------------|
| Domain | Entities, VOs, Events, Interfaces | None |
| Application | Use Cases, Commands, Queries, DTOs | Domain only |
| Infrastructure | EF Core, Redis, HTTP clients | Application, Domain |
| WebApi | Controllers, Middleware | Application only |

### DDD Principles
- Aggregate roots own their consistency boundary
- Domain events for inter-aggregate communication (`IDomainEvent`)
- Specifications pattern for complex business queries
- Value objects for type safety and immutability
- Ubiquitous language reflected in code naming

### CQRS with MediatR
```csharp
// Command: mutates state
public record CreateOrderCommand(Guid CustomerId, List<OrderItemDto> Items) : IRequest<Guid>;

// Query: returns data, no side effects
public record GetOrderByIdQuery(Guid OrderId) : IRequest<OrderDto>;

// Handler follows SRP
public class CreateOrderCommandHandler(IOrderRepository repo, IUnitOfWork uow)
    : IRequestHandler<CreateOrderCommand, Guid>
```

### EF Core Patterns
- `AsNoTracking()` on all read queries
- Batch insert/update with `ExecuteUpdateAsync` / `ExecuteDeleteAsync`
- Projection with `Select()` — never load full entity for reads
- Owned entities for Value Objects
- `IEntityTypeConfiguration<T>` for fluent mapping (no DataAnnotations)

---

## Frontend Patterns (Angular v20+)

### Standalone Components (default)
```typescript
@Component({
  selector: 'app-example',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './example.component.html',
})
export class ExampleComponent { }
```

### Signals — Reactive State
```typescript
// In component or service
count = signal(0);
doubled = computed(() => this.count() * 2);

// In template
{{ count() }}   // call signal as function
@if (isLoading()) { <app-spinner /> }
@for (item of items(); track item.id) { ... }
```

### inject() over Constructor Injection
```typescript
// Preferred
private readonly userService = inject(UserService);
private readonly router = inject(Router);

// Avoid in modern Angular
constructor(private userService: UserService) {}
```

### HTTP with Angular HttpClient
```typescript
private readonly http = inject(HttpClient);

getOrders(): Observable<Order[]> {
  return this.http.get<Order[]>('/api/orders');
}
```

### Control Flow Syntax (Angular 17+)
```html
@if (user()) {
  <app-user-profile [user]="user()!" />
} @else {
  <app-login />
}

@for (item of cart(); track item.id) {
  <app-cart-item [item]="item" />
} @empty {
  <p>Cart is empty</p>
}

@defer (on viewport) {
  <app-heavy-component />
} @placeholder {
  <app-skeleton />
}
```

---

## Database Patterns

### SQL Server (EF Core)
- Use `IDbContextFactory<T>` for long-running background services
- Index strategy: composite indexes matching WHERE + ORDER BY columns
- Always use parameterized queries (EF Core does this automatically)
- Connection string from Azure Key Vault via Managed Identity

### PostgreSQL (EF Core)
- Use `UseNpgsql()` with `EnableRetryOnFailure()`
- `jsonb` columns via `HasColumnType("jsonb")` for semi-structured data
- Npgsql bulk operations for batch inserts

### Redis (StackExchange.Redis)
```csharp
// Cache-aside pattern
public async Task<T?> GetOrSetAsync<T>(string key, Func<Task<T>> factory, TimeSpan ttl)
{
    var cached = await _cache.GetStringAsync(key);
    if (cached != null) return JsonSerializer.Deserialize<T>(cached);
    var value = await factory();
    await _cache.SetStringAsync(key, JsonSerializer.Serialize(value),
        new DistributedCacheEntryOptions { AbsoluteExpirationRelativeToNow = ttl });
    return value;
}
```

---

## Security Standards

- JWT Bearer auth with Azure AD / Entra ID
- Claims-based authorization (`[Authorize(Policy = "RequireAdmin")]`)
- Input validation via FluentValidation (Application layer)
- OWASP Top 10 compliance on all endpoints
- Secrets in Azure Key Vault — never in appsettings.json
- Angular: HTTP interceptor adds `Authorization: Bearer` header
- Angular: No sensitive data in `localStorage`; use `sessionStorage` or in-memory

---

## Performance Standards

- All .NET async paths use `async/await` — no `.Result` or `.Wait()`
- `CancellationToken` passed through all layers
- Redis TTL: reference data 1h, user-specific 5min, ephemeral 30s
- EF Core: avoid `Include()` chains > 3 levels; use projections
- Angular: lazy-load feature routes; defer heavy components with `@defer`
- Angular: `OnPush` change detection on pure display components

---

## Code Review Checklist

### Backend
- [ ] Correct Clean Architecture layer dependencies
- [ ] Domain logic stays in Domain/Application, not Infrastructure
- [ ] Async/await correct (no deadlocks, CancellationToken passed)
- [ ] EF Core: AsNoTracking on reads, projections used
- [ ] FluentValidation on all commands/queries
- [ ] Logging at appropriate levels (no sensitive data logged)
- [ ] Unit tests: xUnit + Moq + FluentAssertions; covers happy path, not-found, validation, exception
- [ ] Test data via Bogus Faker / Builder pattern — no hardcoded magic strings
- [ ] `Verify()` calls confirm side effects (repo.Add, uow.Commit) were called/not called

### Frontend (Angular v20+)
- [ ] Standalone component with correct imports
- [ ] Signals used for reactive state (not BehaviorSubject overuse)
- [ ] `@if`/`@for`/`@defer` used (not `*ngIf`/`*ngFor`)
- [ ] `inject()` used (not constructor injection)
- [ ] `track` expression in `@for`
- [ ] `OnPush` on display components
- [ ] HTTP calls in services, not components
- [ ] Unit tests: Jasmine + TestBed; services mocked via `jasmine.createSpyObj` with signal props
- [ ] `fixture.detectChanges()` after every signal update in tests
- [ ] `httpMock.verify()` in `afterEach` for HTTP service tests

### Database
- [ ] Indexes match query patterns
- [ ] Migrations are reversible (Down() method)
- [ ] No raw SQL without parameterization
- [ ] Redis keys follow naming convention `{service}:{entity}:{id}`

---

---

## Engineering Principles (Non-negotiable)

### 1. Memory Management

**Angular / TypeScript**
- Every `subscribe()` must be cleaned up — use `takeUntilDestroyed(destroyRef)` or convert to `toSignal()`
- `effect()` created outside injection context must be manually destroyed
- `Subject` / `BehaviorSubject` must call `.complete()` in `ngOnDestroy`
- Avoid storing large object references in long-lived services/stores — clear on logout/reset
- Use `@defer` to avoid loading heavy components into memory until needed

```typescript
// ✅ Auto-cleanup — preferred
readonly data = toSignal(this.http.get<Data[]>('/api/data'), { initialValue: [] });

// ✅ takeUntilDestroyed when you must subscribe manually
private readonly destroyRef = inject(DestroyRef);
this.someStream$.pipe(takeUntilDestroyed(this.destroyRef)).subscribe(...);

// ❌ LEAK — no cleanup
this.someStream$.subscribe(...);
```

**.NET / C#**
- `IDisposable` types must always be wrapped in `using` or registered with DI lifetime that matches usage
- Avoid `static` fields holding object references (memory leak in long-running services)
- `DbContext` must be scoped — never singleton; use `IDbContextFactory<T>` in background services
- `HttpClient` must be injected via `IHttpClientFactory` — never `new HttpClient()`
- `CancellationToken` on all async paths — allow resources to be released when requests cancel
- `IAsyncDisposable` for async cleanup; `await using` in handlers

```csharp
// ✅ Proper disposal
await using var db = await _factory.CreateDbContextAsync(ct);

// ✅ HttpClient via factory — connection pooling, no socket exhaustion
services.AddHttpClient<IPaymentClient, PaymentClient>();

// ❌ LEAK — new HttpClient() bypasses pooling
var client = new HttpClient();
```

---

### 2. Generic & Extensible Code

Write logic so it can be reused, extended, or modified with minimal blast radius:
- **Extract to generic base**: repeated patterns → base class, generic service, or utility function
- **Depend on abstractions**: `IRepository<T>`, `ICacheService`, `IEmailSender` — not concrete types
- **Open/Closed**: classes open for extension (via interfaces, strategy pattern), closed for modification
- **Avoid hardcoding**: business rules as configurable constants or strategy objects, not if/else chains
- **Small, composable pieces**: one method does one thing; compose in higher-level callers

```csharp
// ✅ Generic repository — extensible per entity without duplication
public interface IRepository<T> where T : Entity
{
    Task<T?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task<IReadOnlyList<T>> GetAllAsync(CancellationToken ct = default);
    void Add(T entity);
    void Remove(T entity);
}

// ✅ Strategy pattern — add new payment providers without touching existing code
public interface IPaymentGateway { Task<PaymentResult> ChargeAsync(PaymentRequest req); }
public class StripeGateway : IPaymentGateway { ... }
public class PayPalGateway : IPaymentGateway { ... }
```

```typescript
// ✅ Generic base service — reuse across features
abstract class BaseEntityService<T extends { id: string }> {
  protected readonly items = signal<T[]>([]);
  protected readonly isLoading = signal(false);
  readonly count = computed(() => this.items().length);

  protected setItems(data: T[]): void { this.items.set(data); }
  findById(id: string): T | undefined { return this.items().find(i => i.id === id); }
}
```

---

### 3. OOP, Design Patterns, DI & SOLID

Apply these on every design decision:

**SOLID:**
| Principle | Practice |
|-----------|----------|
| **S** — Single Responsibility | One class = one reason to change; handlers do one thing |
| **O** — Open/Closed | Extend via interface + new class, don't modify existing |
| **L** — Liskov | Subtypes must honor base contracts (no `NotImplementedException`) |
| **I** — Interface Segregation | Small focused interfaces (`IReader<T>`, `IWriter<T>`) not fat `IRepository` with 20 methods |
| **D** — Dependency Inversion | Depend on `IService` not `ServiceImpl`; inject via constructor/`inject()` |

**Design Patterns to apply by context:**
| Scenario | Pattern |
|----------|---------|
| Multiple algorithms (payment, export, notification) | **Strategy** |
| Add behavior without modifying class (caching, logging, auth) | **Decorator** |
| Build complex objects step-by-step | **Builder** |
| Single shared instance per scope | **Singleton (via DI)** |
| Observe state changes across components | **Observer (Signals/Events)** |
| Abstract data access | **Repository** |
| Encapsulate complex queries | **Specification** |
| Complex multi-step processes | **Saga / Pipeline** |

**DI Rules:**
- Register all services in DI container — never `new ServiceImpl()` in business code
- Lifetime: Singleton for stateless infra, Scoped for per-request (DbContext), Transient for lightweight
- Angular: `providedIn: 'root'` for app-wide services; feature-level for scoped state
- .NET: `services.AddScoped<IRepo, RepoImpl>()` — test by swapping implementation

---

## Code Documentation (Strict)

Every generated function/method must have a documentation comment. No exceptions.

### C# — XML Doc Comments
```csharp
/// <summary>
/// Brief overview of what this method does (one line preferred).
/// </summary>
/// <param name="orderId">The unique identifier of the order to retrieve.</param>
/// <param name="ct">Cancellation token for the async operation.</param>
/// <returns>The order DTO if found; null otherwise.</returns>
public async Task<OrderDto?> GetByIdAsync(Guid orderId, CancellationToken ct = default)
```

### TypeScript/Angular — JSDoc
```typescript
/**
 * Brief overview of what this method does.
 * @param filters The filter criteria to apply to the product list.
 * @returns Observable emitting the paginated product result.
 */
loadProducts(filters: ProductFilters): Observable<PagedResult<Product>>
```

Rules:
- `<summary>` / first JSDoc line: what it does (not "this method...")
- `<param>` / `@param`: every parameter including `CancellationToken`
- `<returns>` / `@returns`: what is returned, including null/undefined cases
- Skip `@returns` only for `void` / `Promise<void>` methods
- Skip for simple property getters with self-explanatory names

---

## File Conventions (Strict)

### Angular — Always Separate Files
Every component = 4 files, never inline:
```
feature.component.ts      ← class only, templateUrl + styleUrl
feature.component.html    ← template (@if/@for/@defer)
feature.component.scss    ← styles
feature.component.spec.ts ← Jasmine tests
```
- **Never** use `template: \`...\`` inline in component decorator
- Interfaces/types always in `models/*.model.ts` — **never** inside service/store/component files

### .NET — Separate Request/Response
- Request records: `WebApi/{Feature}/Requests/` folder
- Response DTOs: `Application/{Feature}/DTOs/` folder
- **Never** define records/classes inside a Controller file

---

## Prompt Patterns

Always provide:
1. **Context**: Domain, layer, technology version
2. **Current Code**: Paste relevant snippet
3. **Goal**: Performance, security, architecture, test coverage
4. **Constraints**: Scale, deadlines, team skills

Reference templates in `prompts/tasks/` for specific scenarios.
