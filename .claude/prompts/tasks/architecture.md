# Architecture & Design Prompt Templates

---

## Architecture Review / DDD Modeling

```
[architect] Review/design this feature:

**Domain & Context:**
[Mô tả business domain, bounded context]

**Current implementation (nếu có):**
[Paste code hoặc mô tả structure]

**Questions:**
1. [Clean Architecture violations? Layer deps đúng không?]
2. [Aggregate boundaries hợp lý không?]
3. [Domain events cần ở đâu?]

**Constraints:**
- Scale: [expected load]
- Team: [size/expertise]

Provide:
- Architecture assessment (SOLID, DDD correctness)
- Suggested improvements với rationale
- Code examples cho recommended patterns
- Trade-offs và security implications
```

---

## Performance & Microservices Design

```
[architect] Optimize/design communication pattern:

**Performance issue (nếu có):**
[Paste EF Core query / slow endpoint]
- Current latency: [ms] | Target: [ms]
- Data volume: [rows] | Frequency: [calls/min]

**Microservices (nếu có):**
Services: [A] <-> [B] <-> [C]
- Eventual consistency OK for: [operations]
- Strong consistency required for: [operations]

Provide:
- Query / index optimization với explanation
- Caching strategy (Redis TTL, cache-aside vs write-through)
- Service communication pattern (REST / events / Saga)
- Async resilience (retry, circuit breaker via Polly)
```

---

## Security Architecture Review

```
[security-auditor] Review for security vulnerabilities:

**Component:** [API endpoint / Auth flow / DB query]
**Code:**
[Paste code]

Check:
- OWASP Top 10 (injection, broken auth, IDOR, misconfiguration)
- Auth/authz: JWT validation, [Authorize] coverage, claims
- Input validation: FluentValidation coverage
- Secrets: hardcoded credentials, logging PII

Output: vulnerability list với severity (Critical/High/Medium) + remediation code
```
