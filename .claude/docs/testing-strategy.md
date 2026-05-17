# Testing Strategy

Toàn bộ testing approach cho .NET + Angular stack — từ unit đến E2E.

---

## Testing Pyramid

```
         /\
        /E2E\          Playwright — happy path flows only
       /──────\
      /  Integ  \      Testcontainers — real DB, full API
     /────────────\
    /  Unit Tests  \   xUnit + Moq — domain, handlers, services
   /────────────────\
```

**Rule:** Nhiều unit tests, ít integration tests, rất ít E2E tests.

---

## 1. Unit Tests (xUnit + Moq + FluentAssertions)

**Scope:** Domain entities, CQRS handlers, validators, Angular services  
**Speed:** < 1 giây/test  
**Isolation:** 100% mock — không hit DB, network, file system

### Cần test:
- Happy path — valid input, all dependencies succeed
- Not found — entity missing → return null / failure result
- Validation — mỗi rule violation → correct error message
- Business rule violation → `DomainException` với correct message
- Exception propagation — dependency throws → exception propagates
- Side effects — `repo.Add()`, `uow.CommitAsync()` called / not called

### Không cần test:
- EF Core queries (integration test scope)
- Third-party library behavior
- Framework wiring (DI, routing)

**Skill:** `/unit-testing`

---

## 2. Integration Tests (Testcontainers)

**Scope:** Repositories, full API endpoints qua `WebApplicationFactory`  
**Speed:** 10-30 giây (container startup)  
**Isolation:** Real DB container, real Redis container

### Setup:
```
tests/Integration/
├── Fixtures/
│   ├── SqlServerFixture.cs     ← spin up + migrate
│   ├── RedisFixture.cs
│   └── IntegrationWebFactory.cs  ← full API + containers
├── Repositories/
│   └── OrderRepositoryTests.cs
└── Api/
    └── OrdersEndpointTests.cs
```

### Cần test:
- Repository CRUD operations với real data
- EF Core queries: joins, projections, includes
- API endpoints: status codes, response body, headers
- Migration scripts chạy đúng trên real SQL engine
- Concurrency + constraint violations

**Skill:** `/testcontainers`

---

## 3. Snapshot Tests (Verify)

**Scope:** DTO mapping, complex object serialization, API response shape  
**Speed:** < 1 giây/test (same as unit)  
**Isolation:** No external dependencies

### Dùng khi:
- DTO mapping phức tạp nhiều fields
- API response body cần verify exact structure
- Email template rendering

### Không dùng khi:
- Simple boolean / numeric assertions → dùng FluentAssertions
- Output có nhiều unstable values khó scrub

**Skill:** `/snapshot-testing`

---

## 4. Angular Unit Tests (Jasmine + TestBed)

**Scope:** Components, services, pipes, guards  
**Speed:** < 1 giây/test  
**Isolation:** `HttpTestingController` cho HTTP calls, `jasmine.createSpyObj` cho services

### Cần test:
- Service: HTTP calls (correct URL, method, payload), signal state changes
- Component: renders correct state (loading/error/data), user interactions
- Guard: blocks unauthenticated, allows authenticated
- Pipe: transforms input correctly

### Patterns:
```typescript
// Signal mock
const mockService = jasmine.createSpyObj('UserService', ['loadUser'], {
  user: signal<User | null>(null),      // signal property
  isLoading: signal(false)
});

// Flush HTTP in tests
const req = httpMock.expectOne('/api/orders');
expect(req.request.method).toBe('GET');
req.flush(mockOrders);
fixture.detectChanges();               // trigger signal → template update
```

**Skill:** `/unit-testing-angular`

---

## 5. E2E Tests (Playwright)

**Scope:** Critical user flows only — login, checkout, key feature happy paths  
**Speed:** 10-60 giây/flow  
**Isolation:** Full stack running (local or staging env)

### Chỉ test:
- Login → access protected route
- Create → verify in list
- Critical payment / checkout flow

### Không test:
- Every validation message (unit test scope)
- Every error state (integration test scope)
- UI styling

### Setup:
```bash
npm init playwright@latest
npx playwright test --project=chromium
```

---

## 6. Contract Tests (Optional)

**Khi nào cần:** Microservices cần đảm bảo API contract giữa producer và consumer.

Tool: Pact.NET (consumer-driven contract testing)

```csharp
// Consumer: định nghĩa expected API shape
// Provider: verify actual API match expected shape
```

---

## Coverage Targets

| Layer | Minimum | Recommended |
|-------|---------|-------------|
| Domain entities | 90% | 95% |
| CQRS Handlers | 85% | 90% |
| Angular Services | 80% | 85% |
| Repositories | Integration only | |
| Controllers | Integration only | |

```bash
# Generate coverage report
dotnet test --collect:"XPlat Code Coverage"
reportgenerator -reports:"**/coverage.cobertura.xml" -targetdir:"coverage" -reporttypes:Html
```

---

## CI Pipeline Test Stages

```yaml
# Chạy theo thứ tự: nhanh trước, chậm sau
stages:
  - Unit Tests (< 30s)     → fail fast
  - Format Check (< 10s)   → fail fast  
  - Integration Tests (< 2min) → real containers
  - E2E Tests (< 5min)     → staging env only
```

---

## Test Naming Convention

```
MethodName_Condition_ExpectedResult

CreateOrder_ValidInput_ReturnsSuccessWithGuid
CreateOrder_CustomerNotFound_ReturnsFailure
CreateOrder_EmptyItems_ValidationFails
Confirm_AlreadyConfirmed_ThrowsDomainException
```
