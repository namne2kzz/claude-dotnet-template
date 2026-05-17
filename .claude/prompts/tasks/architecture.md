# Architecture Analysis & Design Prompt Template

## For Clean Architecture Validation

Use this prompt when reviewing or designing .NET solutions:

---

### Prompt Template

```
I'm working on a [microservice/feature] in our .NET application with Clean Architecture.

**Current Context:**
- Domain: [Brief description of business domain]
- Current Implementation: [Paste relevant code or describe structure]
- Technologies: [EF Core version, database type, Azure services used]

**Questions/Needs:**
1. Is my architecture aligned with Clean Architecture principles?
2. Are my DDD boundaries correct?
3. How can I optimize this for [performance/scalability]?
4. What security concerns should I address?

**Constraints:**
- [Performance requirements]
- [Scale expectations]
- [Team size/expertise]

Please analyze and provide:
- Architecture assessment against SOLID principles
- Suggested improvements with rationale
- Code examples for recommended patterns
- Performance implications
- Security considerations
```

---

## For DDD Modeling

```
I need help modeling this domain in DDD patterns:

**Business Context:**
[Describe the business process/domain]

**Current Entities/Aggregates:**
[List or show current structure]

**Questions:**
1. What should be my aggregate roots?
2. How should these bounded contexts communicate?
3. Where should domain events be published?

Please suggest:
- Aggregate boundary definitions
- Value objects vs Entities
- Domain event structure
- Anti-corruption layers (if needed)
- Repository interfaces
```

---

## For Microservices Communication

```
I'm designing a microservice communication pattern:

**Services Involved:**
[Service A] <-> [Service B] <-> [Service C]

**Constraints:**
- Eventual consistency is acceptable for [specific operations]
- Strong consistency required for [specific operations]
- Azure Service Bus available

**Current Approach:**
[Describe current implementation or problem]

Recommend:
- Service-to-service communication pattern (REST, events, RPC)
- Async patterns for resilience
- Error handling & retry strategies
- Distributed transaction approach (Saga pattern?)
```

---

## For Performance Optimization

```
Analyze this query performance issue:

**Current Code:**
[Paste EF Core query or database operation]

**Problem:**
[Describe performance issue - slow response time, high memory, etc.]

**Context:**
- Data volume: [rows/records]
- Frequency: [how often called]
- Acceptable latency: [milliseconds]
- Database: [Azure SQL/Cosmos/PostgreSQL]

Suggest:
- Query optimization (Select, Include, AsNoTracking)
- Database indexing strategy
- Caching approach (Redis, distributed cache)
- Architectural changes if needed
- Performance testing approach
```

---

## For Security Review

```
Review this code for security vulnerabilities:

**Component:**
[API endpoint / Database query / Authentication logic]

**Current Implementation:**
[Paste code]

**Threats:**
- [List potential threats you're concerned about]

Please check for:
- OWASP Top 10 vulnerabilities
- Authentication/Authorization flaws
- SQL injection risks
- Data protection issues
- Azure security best practices violations

Provide:
- Vulnerabilities found
- Risk level (Critical/High/Medium)
- Remediation code
- Testing strategy to validate fix
```

---

## For Testing Strategy

```
Help me design tests for this business logic:

**Requirement:**
[Describe business rule/feature]

**Current Implementation:**
[Show entity, service, or business logic]

**Current Test Coverage:**
[Describe existing tests if any]

Please provide:
- Unit test examples (arrange-act-assert)
- Test cases covering edge cases
- Mock/fixture setup
- Integration test strategy
- Performance test approach
```

---

## For Code Review

```
Please review this code for architectural compliance:

**Code:**
[Paste code block or file]

**Context:**
- Layer: [Domain/Application/Infrastructure/WebApi]
- Purpose: [What this code does]
- Performance-critical: [Yes/No]

Check for:
- SOLID principle compliance
- DDD pattern correctness
- Clean code practices
- Performance issues
- Security concerns
- Test coverage expectations

Rate:
- Architecture alignment (1-5)
- Code quality (1-5)
- Performance readiness (1-5)
- Security posture (1-5)
```

---

Use these templates to get more focused, architectural responses from Claude.
