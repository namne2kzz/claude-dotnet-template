# Code Review Prompt Template

## For .NET Code Review

```
Please review this C# code for production readiness:

**Code Context:**
- Project: [Microservice/Feature name]
- Layer: [Domain/Application/Infrastructure/WebApi]
- Dependencies: [EF Core, MediatR, etc.]

**Code to Review:**
[Paste code]

**Review Focus Areas:**
- SOLID principles compliance
- Exception handling
- Async/await correctness
- Performance impact
- Security vulnerabilities
- Unit test feasibility

**Specific Questions:**
1. [Question about design]
2. [Question about performance]
3. [Question about security]

Please provide:
- Compliance score (1-5) for each area
- Specific issues found
- Refactored code examples
- Explanation of improvements
- Test coverage recommendations
```

---

## For API Design Review

```
Review my API endpoint design:

**Endpoint:**
[HTTP Method] /api/v1/[resource]/[action]

**Current Implementation:**
[Paste controller action]

**Expected Behavior:**
[Describe what endpoint should do]

**Questions:**
- Is my DTOs structure appropriate?
- Proper HTTP status codes?
- Adequate error handling?
- Security is correct?
- Performance optimized?

Check for:
- RESTful compliance
- Versioning strategy
- Request/Response validation
- Authorization checks
- Rate limiting needs
- Documentation completeness
```

---

## For Database Query Optimization

```
Optimize this database query performance:

**Current Query:**
[Paste LINQ/SQL]

**Performance Metrics:**
- Current response time: [ms]
- Data size: [rows]
- Execution frequency: [times/minute]
- Target latency: [ms]

**Execution Plan:** (if available)
[Paste execution plan or database statistics]

Suggest:
- Query restructuring
- Index recommendations
- Caching strategy
- Batch processing approach
- Denormalization if beneficial

Provide:
- Optimized query with explanation
- Expected performance improvement
- Trade-offs involved
- Implementation steps
```

---

## For Unit Test Writing

```
Help me write comprehensive unit tests:

**Code to Test:**
[Paste class/method]

**Business Logic:**
[Describe what logic should do]

**Edge Cases:**
[List important edge cases]

**Dependencies:**
[List dependencies to mock]

Provide:
- Test class scaffold
- 5-7 test cases covering:
  - Happy path
  - Edge cases
  - Error scenarios
  - Boundary conditions
- Mock setup code
- Assertion best practices
```

---

## For Integration Test Design

```
Design integration tests for this feature:

**Feature:**
[Describe end-to-end flow]

**Affected Systems:**
- Database: [Type and tables]
- External Services: [List]
- Message Queue: [If used]

**Test Scenarios:**
1. [Happy path]
2. [Error case 1]
3. [Error case 2]
4. [Rollback scenario]

Current Implementation:
[Paste service/controller code]

Provide:
- Test setup/teardown strategy
- Database seeding approach
- External service mocking
- Assertion strategy
- Performance test case
```

---

## For Async/Await Review

```
Review this async/await implementation:

**Code:**
[Paste async method]

**Usage Context:**
[Where this is called from]

**Potential Issues:**
[List concerns if any]

Check for:
- Proper async all the way up
- No .Result or .Wait() blocking
- Correct ConfigureAwait usage
- Exception handling in async context
- Cancellation token usage
- Deadlock risks
- Performance implications

Provide:
- Issues found
- Corrected code
- Explanation of async best practices
```

