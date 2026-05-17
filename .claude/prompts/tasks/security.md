# Security & Testing Prompt Templates

## Security Audit Prompt Template

```
Conduct a comprehensive security audit of this code:

**Component Type:**
- [ ] API Endpoint
- [ ] Database Query
- [ ] Authentication Service
- [ ] Payment Processing
- [ ] Data Export
- [x] [Specify type]

**Code:**
[Paste the code to review]

**Context:**
- Layer: [Domain/Application/Infrastructure/WebApi]
- Sensitivity: [Low/Medium/High/Critical]
- User-facing: [Yes/No]
- Handles PII: [Yes/No]
- Financial data: [Yes/No]
- External users: [Yes/No]

**Threat Model:**
Potential threats include:
- [SQL injection from user input]
- [Unauthorized data access]
- [Cross-site scripting (XSS)]
- [[Specify other threats]]

**Current Security Measures:**
[Describe existing security controls]

**Compliance Requirements:**
- GDPR: [Yes/No]
- HIPAA: [Yes/No]
- PCI-DSS: [Yes/No]
- SOC2: [Yes/No]
- Other: [Specify]

Please provide:

1. **Vulnerability Assessment**
   - Severity: [Critical/High/Medium/Low]
   - OWASP Category: [A01, A02, etc.]
   - Description of vulnerability
   - Exploitation scenario
   - Impact assessment

2. **For Each Vulnerability Found:**
   - **Issue**: [Clear description]
   - **Risk**: [Business impact]
   - **Current State**: [How it's vulnerable]
   - **Secure Code**: [Fixed implementation]
   - **Explanation**: [Why this is more secure]

3. **OWASP Top 10 Checklist:**
   - [ ] A01:2021 – Broken Access Control
   - [ ] A02:2021 – Cryptographic Failures
   - [ ] A03:2021 – Injection
   - [ ] A04:2021 – Insecure Design
   - [ ] A05:2021 – Security Misconfiguration
   - [ ] A06:2021 – Vulnerable & Outdated Components
   - [ ] A07:2021 – Authentication Failures
   - [ ] A08:2021 – Software & Data Integrity Failures
   - [ ] A09:2021 – Logging & Monitoring Failures
   - [ ] A10:2021 – Server-Side Request Forgery (SSRF)

4. **Azure-Specific Security Issues:**
   - Key Vault integration missing?
   - Managed Identity not used?
   - Network security groups misconfigured?
   - Storage account public access?
   - CosmosDB encryption?
   - Service Bus authentication?

5. **Authentication & Authorization:**
   - JWT token validation proper?
   - Claims-based authorization?
   - Role-based access control (RBAC)?
   - Scope validation?
   - Token expiration?
   - Refresh token rotation?

6. **Data Protection:**
   - Encryption in transit (TLS)?
   - Encryption at rest?
   - Sensitive data in logs?
   - PII data handling?
   - Secrets management?
   - Secure password hashing?

7. **Input Validation:**
   - All user inputs validated?
   - Type checking?
   - Length restrictions?
   - Format validation?
   - Encoding/escaping?

8. **Remediation Plan:**
   - Priority ranking
   - Implementation order
   - Testing approach
   - Deployment strategy
   - Monitoring post-fix

9. **Testing Recommendations:**
   - Security test cases
   - Penetration testing areas
   - Automated scanning tools
   - Code review checklist

10. **Compliance Impact:**
    - Compliance mapping (GDPR/HIPAA/PCI)
    - Data retention requirements
    - Audit trail needs
    - Documentation requirements

11. **Security Score:** [1-10]
    - Explanation of rating
    - Improvement priorities
```

---

## Unit Testing Prompt Template

```
Help me write comprehensive unit tests:

**Class/Method to Test:**
[Paste the code]

**Business Logic:**
[Describe what this code should do]

**Current Test Coverage:**
[Describe existing tests, if any]

**Dependencies:**
- Database: [Yes/No - type if yes]
- External APIs: [Yes/No - which ones]
- Services: [List]
- Configuration: [Yes/No]
- Logging: [Yes/No]

**Edge Cases to Cover:**
1. [Edge case 1]
2. [Edge case 2]
3. [Boundary condition 1]
4. [Error scenario 1]

**Framework:**
- Testing: [xUnit/NUnit]
- Mocking: [Moq/NSubstitute]
- Assertions: [FluentAssertions/Shouldly]

Please provide:

1. **Test Class Structure**
   - Test class scaffold
   - Naming conventions
   - Setup/Teardown pattern

2. **Test Cases** (8-12 comprehensive tests)
   - Happy path test
   - [Specific business logic tests]
   - Edge case tests (2-3)
   - Error/exception tests (2-3)
   - Boundary condition tests (2-3)

3. **For Each Test:**
   - Test name (Following Given_When_Then pattern)
   - Arrange section (setup)
   - Act section (execute)
   - Assert section (verify)
   - Comments explaining logic

4. **Mock Setup**
   - Mock object creation
   - Behavior configuration
   - Verification assertions
   - AutoFixture usage (if applicable)

5. **Test Data**
   - Builder pattern for complex objects
   - Factory methods
   - Common test data sets
   - Randomized vs fixed data

6. **Code Coverage**
   - Expected coverage % (aim for 80%+)
   - Coverage analysis hints
   - Uncovered code explanation
   - Why certain paths may not be testable

7. **Performance Tests** (optional)
   - Benchmark for critical paths
   - Expected timing ranges
   - Performance regression detection

8. **Maintainability**
   - Test readability improvements
   - DRY principle in tests
   - Custom assertions/helpers
   - Test organization tips

9. **Complete Test File**
   [Full, ready-to-run test file]

10. **Integration with CI/CD**
    - Test execution in pipelines
    - Code coverage reporting
    - Failure notification
    - Performance tracking
```

---

## Integration Testing Prompt Template

```
Design integration tests for this feature:

**Feature Description:**
[What does this feature do end-to-end?]

**User Story/Scenario:**
[Describe the user flow]

**Components Involved:**
1. [API endpoint] -> [Database table] -> [External service]
2. [Service A] -> [Service B] -> [Message queue]
3. [Frontend] -> [Backend] -> [Azure storage]

**Technology Stack:**
- Database: [Azure SQL/PostgreSQL]
- Message Queue: [Service Bus/RabbitMQ]
- Cache: [Redis/In-memory]
- External APIs: [List]
- Microservices: [List]

**Code to Test:**
[Paste the complete feature code]

**Test Scenarios:**
1. **Happy Path**
   - [Complete successful flow]
   - Expected outcomes
   - Database state changes
   - Events published

2. **Error Scenarios**
   - [Scenario 1]: Database connection failure
   - [Scenario 2]: External API timeout
   - [Scenario 3]: Message queue unavailable
   - [Scenario 4]: [Custom scenario]

3. **Data Validation**
   - Valid input processing
   - Invalid input rejection
   - Boundary condition handling

4. **Concurrency**
   - [Scenario]: Simultaneous requests
   - [Scenario]: Duplicate submissions
   - [Scenario]: Race conditions

5. **State Management**
   - Initial state
   - State transitions
   - Final state verification

**Current Implementation:**
[Paste relevant service/controller code]

Please provide:

1. **Test Setup**
   - Database initialization
   - Service dependencies
   - Mocking strategy (what to mock vs real)
   - Test data seeding

2. **Test Infrastructure**
   - Test fixture base class
   - Database context setup/teardown
   - External service mocking
   - Message queue simulation

3. **Test Cases** (5-8 integration tests)
   - [Happy path test]
   - [Error handling tests]
   - [Concurrency tests]
   - [Data consistency tests]
   - [Event publishing tests]

4. **For Each Test:**
   - Clear test name
   - Arrange: Setup test data & services
   - Act: Execute the feature flow
   - Assert: Verify all state changes
   - Cleanup: Database rollback

5. **Database Testing**
   - Migration testing
   - Rollback verification
   - Data consistency checks
   - Index usage verification

6. **Event Verification**
   - Domain events published?
   - Correct event data?
   - Event ordering?
   - Event handler execution?

7. **External Service Mocking**
   - Mock setup for APIs
   - Success/failure scenarios
   - Timeout handling
   - Retry behavior

8. **Assertion Strategies**
   - Database state validation
   - Returned data verification
   - Side effects confirmation
   - Event emission verification

9. **Performance Baseline**
   - Expected execution time
   - Resource usage monitoring
   - Performance regression detection

10. **CI/CD Integration**
    - Test execution command
    - Database setup in pipeline
    - Parallel execution considerations
    - Reporting & dashboards

11. **Complete Test File**
    [Full, ready-to-run integration test file]

12. **Troubleshooting Guide**
    - Common test failures
    - Debug strategies
    - Flaky test handling
    - Local vs CI environment differences
```

---

## Performance Testing Prompt Template

```
Design performance tests for critical operations:

**Operation to Test:**
[API endpoint / Database query / Batch operation]

**Current Performance:**
- Response time: [ms]
- Throughput: [requests/sec]
- Error rate: [%]

**Performance Targets:**
- Response time (p95): [ms]
- Response time (p99): [ms]
- Throughput: [requests/sec]
- Error rate: [< %]
- Concurrent users: [number]

**Load Profile:**
- Ramp-up: [requests/sec/minute]
- Peak load: [requests/sec]
- Duration: [minutes]
- Think time: [seconds between requests]

**Code to Test:**
[Paste relevant implementation]

**Dependencies:**
- Database queries: [Yes/No]
- External APIs: [Yes/No - which ones]
- Cache usage: [Yes/No]
- Message publishing: [Yes/No]

Provide:

1. **Test Scenarios**
   - Baseline test (single user)
   - Ramp-up test (gradual increase)
   - Sustained load test
   - Spike test (sudden spike)
   - Stress test (beyond expected load)
   - Soak test (extended duration)

2. **Performance Test Script**
   - Tool recommendation (k6, JMeter, NBomber)
   - Test code/configuration
   - Request patterns
   - Data generation strategy

3. **Metrics to Capture**
   - Response times (min, max, p50, p95, p99)
   - Throughput (requests/sec)
   - Error rates (by type)
   - Resource utilization (CPU, memory)
   - Database metrics (queries/sec, locks)
   - Network metrics (bandwidth, latency)

4. **Analysis Approach**
   - Performance baseline establishment
   - Bottleneck identification
   - Resource contention detection
   - Regression detection

5. **Thresholds & Alerts**
   - Response time thresholds
   - Error rate thresholds
   - Resource utilization alerts
   - Automated failure conditions

6. **Reporting**
   - Results visualization
   - Executive summary
   - Detailed analysis
   - Recommendations

7. **Continuous Performance Testing**
   - CI/CD integration
   - Automated execution schedule
   - Historical trend tracking
    - Alert configuration
```

---

Use these templates for thorough security reviews and comprehensive testing strategies.
