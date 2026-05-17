# Hook: Post-Generation Review

Checks to run AFTER Claude generates code to verify quality before use.

## When to Apply
After receiving generated code — before copying to project.

---

## Post-Generation Checklist

### Backend (.NET) — Run after every generated C# file

```
Review the generated C# code for:

**Layer compliance**:
- [ ] No forbidden imports (e.g., EF Core in Domain, DbContext in Application)
- [ ] Correct namespace matches folder structure

**Code quality**:
- [ ] Primary constructors used where appropriate
- [ ] `async Task` / `CancellationToken` on all I/O methods
- [ ] `AsNoTracking()` on read queries
- [ ] No `.Result` / `.Wait()` blocking calls
- [ ] `using` statements for IDisposable resources

**Memory & Resources**:
- [ ] All `IDisposable` wrapped in `using` / `await using`
- [ ] No `new HttpClient()` — uses `IHttpClientFactory`
- [ ] `DbContext` not injected into Singleton services
- [ ] `CancellationToken` threaded through all async calls
- [ ] No `static` mutable fields in long-running services

**Design (SOLID & Patterns)**:
- [ ] Class has a single, clear responsibility (SRP)
- [ ] Depends on interfaces, not concrete implementations (DIP)
- [ ] No `new ConcreteService()` in business logic — uses DI
- [ ] Repeated logic extracted to generic base or shared utility (Open/Closed)
- [ ] No long if/else chains for domain rules — consider Strategy pattern

**Documentation**:
- [ ] Every method has `/// <summary>` (what it does)
- [ ] Every parameter has `/// <param name="...">` including CancellationToken
- [ ] Every non-void method has `/// <returns>`
- [ ] Summary is meaningful — not just restating the method name

**Security**:
- [ ] No hardcoded credentials or connection strings
- [ ] No sensitive data in log statements
- [ ] Authorization attribute on controller action

**Tests** (xUnit + Moq + FluentAssertions):
- [ ] Test class has at least: happy path, not-found, validation failure, exception propagation
- [ ] All interface dependencies mocked with `new Mock<IXxx>()` — no concrete types
- [ ] `Verify()` calls confirm side effects (repo.Add, uow.Commit) were/were not called
- [ ] Test data built with Bogus `Faker<T>` or Builder helpers — no unexplained magic strings
- [ ] `[Theory] + [InlineData]` for multi-value validation cases
- [ ] `Callback<T>` used when verifying exact argument values passed to mock
- [ ] Assertions check specific values (`.Be(id)`, `.Contain("not found")`), not just `.BeTrue()`
```

### Frontend (Angular v20+) — Run after every generated component/service

```
Review the generated Angular code for:

**Modern patterns**:
- [ ] `standalone: true` present
- [ ] `imports: []` array has all needed modules
- [ ] `inject()` used (not constructor injection)
- [ ] `@if`/`@for` used (not `*ngIf`/`*ngFor`)
- [ ] `track` expression in every `@for`
- [ ] `ChangeDetectionStrategy.OnPush` on display components

**Signals**:
- [ ] `signal()` / `computed()` / `effect()` used for state
- [ ] No direct mutation of signal values (`push`, `splice`)
- [ ] `signal.update(fn)` used for derived updates

**Memory Management**:
- [ ] No bare `subscribe()` — uses `takeUntilDestroyed()` or `toSignal()`
- [ ] `Subject` / `BehaviorSubject` completed in `ngOnDestroy` if present
- [ ] Long-lived store has `reset()` method for logout/cleanup
- [ ] Heavy sections use `@defer` to avoid eager memory load

**Design (SOLID & Patterns)**:
- [ ] Component has one responsibility — no HTTP calls in component
- [ ] Service depends on injected dependencies, not `new ConcreteClass()`
- [ ] Repeated logic extracted to base service or utility — not copied
- [ ] State mutations go through store actions, not direct signal writes from components

**Documentation**:
- [ ] Every public method has JSDoc `/** ... */`
- [ ] First line: what it does (not "This method...")
- [ ] `@param` for every parameter
- [ ] `@returns` for non-void methods (include null/undefined cases)

**TypeScript**:
- [ ] No implicit `any`
- [ ] Null checks present (optional chaining `?.`, nullish coalescing `??`)
- [ ] Proper interface/type definitions for API responses

**Tests** (Jasmine + TestBed):
- [ ] `TestBed.configureTestingModule` with correct imports array (standalone → `imports`, not `declarations`)
- [ ] Services mocked via `jasmine.createSpyObj('S', ['method'], { signalProp: signal(value) })`
- [ ] Signal properties cast to `WritableSignal<T>` before `.set()` in tests
- [ ] `fixture.detectChanges()` called after every signal update
- [ ] `httpMock.verify()` in `afterEach` for HTTP service tests
- [ ] Template tests assert visible DOM behavior, not component internals
- [ ] Covers: component creation, ngOnInit calls, loading/error/empty/loaded states, user interactions
- [ ] Builder functions in `tests/builders/` for test data — no inline magic values
```

---

## Post-Generation Prompt
```
Review the code you just generated and verify:

1. Does it follow the patterns in `.claude/memory/patterns.md`?
2. Does it avoid the anti-patterns in `.claude/memory/mistakes.md`?
3. Is there anything in the generated code that should be flagged?
4. Are the tests comprehensive enough (not just smoke tests)?
5. What would you improve if you had more time/context?

If you find issues, fix them before showing the final code.
```
