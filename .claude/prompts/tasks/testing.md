# Testing Strategy & Implementation Prompts

## Complete Testing Strategy Template

```
I need a complete testing strategy for my application:

**Application Overview:**
- Type: [API/Web App/Microservice]
- Architecture: [Monolithic/Microservices]
- Domain: [E-commerce/Banking/Social/Healthcare/Other]
- Critical Operations: [List 3-5 critical flows]

**Current State:**
- Existing test coverage: [%]
- Testing tools: [xUnit/NUnit/xUnit, Moq/NSubstitute]
- CI/CD: [Azure DevOps/GitHub Actions]
- Team size: [number of developers]

**Requirements:**
- Business criticality: [Low/Medium/High]
- Compliance needs: [GDPR/HIPAA/PCI-DSS/None]
- Performance requirements: [Latency SLAs]
- Scalability requirements: [Peak users/transactions]

**Current Gaps:**
- No unit tests for [Layer/Component]
- Limited integration test coverage
- No performance testing
- [Describe other gaps]

Provide:

1. **Testing Pyramid**
   - Unit tests: [%] - Testing what
   - Integration tests: [%] - Testing what
   - E2E tests: [%] - Testing what
   - Performance tests: [%] - Testing what

2. **Unit Testing Strategy**
   - What to unit test (business logic)
   - What not to unit test (framework code)
   - Test organization structure
   - Mocking strategy for dependencies
   - Assert library recommendations
   - Code coverage targets ([x]% target)

3. **Integration Testing Strategy**
   - Database testing approach
   - External service mocking vs real calls
   - Test data management
   - Database transaction handling
   - Test isolation approach
   - Scope of integration tests

4. **API Testing Strategy**
   - HTTP contract testing
   - Request/Response validation
   - Error response testing
   - Status code verification
   - Timeout handling
   - Rate limiting testing

5. **Database Testing Strategy**
   - Migration testing
   - Data migration verification
   - Query performance testing
   - Data integrity checking
   - Concurrency testing
   - Backup & recovery testing

6. **Performance Testing Strategy**
   - Load profile definition
   - Bottleneck identification process
   - Performance regression detection
   - Capacity planning approach
   - Tool recommendations (k6/JMeter/NBomber)

7. **Security Testing Strategy**
   - Vulnerability scanning tools
   - Dependency vulnerability checking
   - OWASP Top 10 testing
   - Authentication testing
   - Authorization testing
   - Encryption validation

8. **Testing Throughout SDLC**
   - Pre-commit hooks (linting, format)
   - Build stage testing
   - Pre-deployment testing
   - Post-deployment smoke tests
   - Continuous monitoring

9. **Test Data Management**
   - Test data generation strategy
   - Fixtures vs factories vs builders
   - Sensitive data handling
   - Test data cleanup
   - Data privacy in tests

10. **CI/CD Integration**
    - Test execution in pipelines
    - Parallel test execution
    - Test result reporting
    - Coverage reporting
    - Performance tracking
    - Test failure notifications

11. **Test Documentation**
    - Test strategy document outline
    - Test case templates
    - Test data dictionary
    - Known limitations
    - Maintenance guidelines

12. **Tools & Framework Stack**
    - Unit testing framework
    - Mocking framework
    - Integration testing approach
    - Performance testing tool
    - Code coverage tool
    - Test reporting tool

13. **Implementation Roadmap**
    - Phase 1: [Quick wins - critical paths]
    - Phase 2: [Comprehensive coverage]
    - Phase 3: [Performance & security testing]
    - Timeline for each phase

14. **Team Training**
    - Testing practices to teach
    - Code review focus areas
    - Common mistakes to avoid
    - Tooling training sessions
```

---

## End-to-End Testing Strategy

```
Design comprehensive E2E tests for user workflows:

**Critical User Workflows:**
1. **[Workflow 1]**: [Step 1] -> [Step 2] -> [Step 3] -> [Success condition]
2. **[Workflow 2]**: [Step 1] -> [Step 2] -> [Step 3] -> [Success condition]
3. **[Workflow 3]**: [Step 1] -> [Step 2] -> [Step 3] -> [Success condition]

**Technology Stack:**
- Frontend: [Angular/React]
- Backend API: [.NET/Node.js]
- Browser: [Chrome/Edge/Firefox]
- E2E Framework: [Playwright/Cypress/Protractor]

**Application Stack:**
[Describe the tech stack - .NET, Angular, Azure, etc.]

**Test Environment:**
- Test server URL: [URL]
- Database reset strategy: [Automated/Manual]
- External service mocking: [Yes/No]
- Test data: [Precreated/Generated per test]

Provide:

1. **E2E Test Scenarios** (one per user workflow)
   - Test case name
   - Preconditions
   - Step-by-step actions
   - Expected results
   - Cleanup/teardown

2. **Test Implementation**
   - Page Object Model structure
   - Helper methods for common actions
   - Wait strategies for async operations
   - Error handling/recovery

3. **Test Data**
   - User accounts for testing
   - Test data seeding strategy
   - Cleanup between tests
   - Sensitive data handling

4. **Failure Handling**
   - Retry mechanisms for flaky steps
   - Screenshot capture on failure
   - Video recording (optional)
   - Detailed error reporting

5. **Performance Assertions**
   - Page load time expectations
   - API response time expectations
   - Overall workflow execution time
   - Performance regression detection

6. **Accessibility Testing**
   - WCAG 2.1 compliance level
   - Keyboard navigation
   - Screen reader compatibility
   - Color contrast validation

7. **CI/CD Integration**
   - Test execution schedule
   - Parallel execution strategy
   - Browser coverage (multiple browsers)
   - Headless vs headed execution

8. **Reporting & Dashboards**
   - Pass/fail results
   - Failure categorization
   - Performance metrics
   - Trend analysis
   - Flaky test identification

9. **Maintenance**
   - Handling UI changes
   - Updating test data
   - Framework upgrades
   - Obsolete test removal
```

---

## Data-Driven Testing Template

```
Set up data-driven tests for comprehensive coverage:

**Scenarios to Test:**
[List different input combinations/conditions]

**Test Data Matrix:**
[Describe ranges, valid/invalid values, edge cases]

**Current Implementation:**
[Paste code to be tested]

Please provide:

1. **Test Data Sets**
   - Input data table
   - Expected outputs
   - Edge cases
   - Boundary values
   - Invalid inputs

2. **Parameterized Test Structure**
   - Using [TestMethod]/[Theory]
   - Test data sources
   - Parameter passing
   - Result comparison

3. **Test Implementation**
   - Base test method with parameters
   - Data provider/fixture
   - Assertion per scenario
   - Named test cases

4. **Performance Considerations**
   - Test execution time
   - Large dataset handling
   - Parallel execution
   - Resource cleanup

5. **Reporting**
   - Individual scenario results
   - Coverage summary
   - Failure analysis
```

---

## Regression Testing Template

```
Design regression test suite:

**Features/Components:**
[List features that need regression testing]

**Known Issues/Regressions:**
[Document past bugs/regressions]

**Frequency:**
- [Daily/Weekly/Per Release]

Provide:

1. **Regression Test Suite**
   - Critical path tests
   - Recent fix verification
   - Integration point tests
   - Performance regression checks

2. **Test Prioritization**
   - High-risk areas
   - Frequently changed code
   - Critical functionality

3. **Execution Strategy**
   - Full vs quick regression run
   - CI/CD integration
   - Automated reporting
   - Issue tracking integration

4. **Metrics to Track**
   - Pass/fail rates
   - Regression detection speed
   - Coverage trends
   - Fix verification success
```

---

## Load & Stress Testing Template

```
Design load and stress tests:

**Service/Operation:**
[API endpoint / Database operation / Batch job]

**Load Profile:**
- Normal load: [requests/sec]
- Peak load: [requests/sec]
- Stress threshold: [requests/sec]
- Expected user growth: [%/month]

**SLAs:**
- Response time (p95): [ms]
- Availability: [%]
- Error rate: [%]

**Infrastructure:**
[Current setup, scaling capabilities]

Provide:

1. **Load Test Scenarios**
   - Gradual ramp-up
   - Sustained load
   - Spike testing
   - Stress testing
   - Endurance testing

2. **Test Implementation**
   - Load testing tool config
   - Request profiles
   - Performance metrics
   - Success criteria

3. **Bottleneck Analysis**
   - Resource utilization monitoring
   - Bottleneck identification
   - Scaling recommendations
   - Cost-performance trade-offs

4. **Reporting & Next Steps**
   - Performance baseline
   - SLA compliance assessment
   - Recommendations
   - Capacity planning
```

---

## Mutation Testing Template

```
Improve test quality with mutation testing:

**Code Coverage:**
[Current coverage %]

**Test Suite:**
[xUnit/NUnit tests]

**Goal:**
[Increase mutation score to %]

Provide:

1. **Mutation Testing Setup**
   - Tool: Stryker.NET configuration
   - Thresholds to set
   - Exclusion rules

2. **Mutation Score Analysis**
   - Weak test identification
   - Coverage gaps
   - Assertions to strengthen

3. **Test Improvements**
   - Tests to add/strengthen
   - New assertions
   - Edge cases to cover

4. **Continuous Improvement**
   - Mutation score tracking
   - CI/CD integration
   - Target setting
```

---

Use these templates to design comprehensive, maintainable testing strategies for your applications.
