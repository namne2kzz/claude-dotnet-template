# Eval: Code Quality Assessment

Criteria for evaluating AI-generated code quality.

## How to Use
After Claude generates code, run this eval by pasting the generated code and asking Claude to score it against these criteria.

---

## Backend (.NET) Evaluation

```
Evaluate this generated .NET code against these criteria (score each 1-5):

[Paste generated code]

### Architecture (1-5)
- 5: Perfect layer separation, no violations, correct abstractions
- 3: Minor violations or missing abstractions
- 1: Major violations (domain logic in controller, EF Core in domain)

### Code Quality (1-5)
- 5: Primary constructors, C# 14 features, clear naming, no magic values
- 3: Mostly good but some issues (long methods, unclear names)
- 1: Hard to read, complex methods, many magic values

### Error Handling (1-5)
- 5: Result<T> pattern, all exceptions caught and logged, CancellationToken
- 3: Some exception handling, CancellationToken sometimes missing
- 1: No error handling, exceptions swallowed or unhandled

### Performance (1-5)
- 5: AsNoTracking, projections, no N+1, cache used appropriately
- 3: Some optimizations missing
- 1: Full entity loads, N+1 issues, no AsNoTracking

### Security (1-5)
- 5: Authorization present, input validated, no sensitive data in logs
- 3: Some security measures but gaps
- 1: No auth check, no input validation, sensitive data logged

### Test Quality (1-5)
- 5: Happy path + edge cases + error cases, clear AAA structure
- 3: Basic happy path only, limited assertions
- 1: No tests or trivial smoke tests

**Total: /30 — Report: Excellent (25+) / Good (20-24) / Needs Work (<20)**
```

---

## Frontend (Angular v20+) Evaluation

```
Evaluate this generated Angular code (score each 1-5):

[Paste component/service code]

### Modern Patterns (1-5)
- 5: Standalone, inject(), @if/@for, Signals, OnPush everywhere correct
- 3: Most modern patterns but some *ngIf or constructor injection remaining
- 1: Old patterns throughout (modules, *ngIf, constructor injection)

### Reactivity (1-5)
- 5: Signals for all state, computed for derived, toSignal for HTTP, no BehaviorSubject
- 3: Mix of Signals and BehaviorSubject
- 1: All BehaviorSubject/Observable based state

### Type Safety (1-5)
- 5: No `any`, proper interfaces for all DTOs, strict null checks
- 3: Some `any` or missing null checks
- 1: Many `any` types, no interfaces

### Template Quality (1-5)
- 5: Clean template, @defer for heavy parts, track in @for, no logic in template
- 3: Mostly clean but some complex expressions
- 1: Complex logic in template, no track, no @defer

### Test Quality (1-5)
- 5: TestBed setup correct, Signals tested, HTTP mocked
- 3: Basic component creation test only
- 1: No tests

**Total: /25 — Report: Excellent (21+) / Good (16-20) / Needs Work (<16)**
```

---

## Database Eval

```
Evaluate this EF Core / SQL code (score each 1-5):

[Paste query/config/migration]

### Query Efficiency (1-5)
- 5: Projection used, AsNoTracking, index-friendly WHERE, no N+1
- 3: Some inefficiencies but not critical
- 1: Full entity loads, N+1 present

### Migration Safety (1-5)
- 5: Down() implemented, zero-downtime approach, online index creation
- 3: Down() present but not all cases covered
- 1: No Down(), destructive without safety

### Index Strategy (1-5)
- 5: Composite indexes match query patterns, covering indexes for frequent queries
- 3: Basic single-column indexes
- 1: No indexes on FK columns, no consideration of query patterns

**Total: /15 — Report: Excellent (13+) / Good (10-12) / Needs Work (<10)**
```
