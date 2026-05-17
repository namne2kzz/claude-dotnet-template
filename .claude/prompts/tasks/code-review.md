# Code Review Prompt Templates

---

## General Code Review (Backend + Frontend)

```
[reviewer] Review this code for production readiness:

**Context:**
- Layer: [Domain / Application / Infrastructure / WebApi / Angular Component / Service]
- Purpose: [What this code does]
- Performance-critical: [Yes / No]

**Code:**
[Paste code]

**Focus areas (chọn những gì relevant):**
- [ ] Clean Architecture layer violations
- [ ] Async/await correctness (no .Result/.Wait(), CT passed)
- [ ] Memory leaks (IDisposable, subscribe cleanup, HttpClient)
- [ ] EF Core: AsNoTracking, projections, N+1 queries
- [ ] Security: [Authorize], FluentValidation, no hardcoded secrets
- [ ] Angular: signals, @if/@for/@defer, inject(), OnPush, standalone

Output: Critical 🔴 / Warning 🟡 / Suggestion 💡 với fixed code examples
```

---

## Testing Review

```
[reviewer] Review / generate tests for:

**Code to test:**
[Paste class / method / component]

**Test cases cần cover:**
- Happy path: [describe]
- Not found / empty: [describe]
- Validation failures: [field → rule]
- Business rule violations: [describe]
- Exception propagation: [describe]

**Stack:** [xUnit + Moq + FluentAssertions | Jasmine + TestBed]
**Dependencies to mock:** [list interfaces / services]

Provide: complete test class với AAA structure, Bogus builders, Verify() on side effects
```

---

## DB Query & Async Review

```
[reviewer] Review this query / async code:

**Code:**
[Paste LINQ / EF Core query / async method]

**Metrics (nếu có):**
- Response time: [ms] | Target: [ms]
- Data volume: [rows] | Frequency: [calls/min]

Check:
- Missing AsNoTracking(), unnecessary Include() chains
- N+1 query patterns
- Missing index recommendations
- async all-the-way-up (no .Result/.Wait())
- CancellationToken propagation
- ConfigureAwait usage

Output: optimized code + index DDL + explanation of improvements
```
