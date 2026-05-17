# Performance Optimization Prompt Template

## For EF Core Query Optimization

```
I need to optimize this slow Entity Framework Core query:

**Current Code:**
[Paste LINQ query]

**Performance Metrics:**
- Current execution time: [ms]
- Data volume: [number of records]
- Query frequency: [times per minute/hour]
- Target latency: [ms]
- Environment: [Development/Production]

**Database:**
- Type: [SQL Server/PostgreSQL/MySQL]
- Edition: [Standard/Premium for Azure SQL]
- Storage: [Approximate database size]

**Execution Plan** (optional):
[Paste SQL execution plan if available from SSMS]

**Related Entities/Tables:**
[List involved tables and relationships]

**Current Performance Profile:**
- CPU usage: [%]
- Memory usage: [MB]
- IO operations: [reads/writes]

Please analyze and provide:
1. **Identified Issues**
   - N+1 query problems
   - Missing indexes
   - Inefficient JOINs
   - Materialized data overhead

2. **Optimized Query**
   - Revised LINQ code
   - SQL equivalent (if helpful)
   - Explanation of improvements

3. **Database Recommendations**
   - Index creation scripts
   - Statistics updates needed
   - Partitioning suggestions

4. **Caching Strategy**
   - What to cache (query results, reference data)
   - Cache invalidation approach
   - Redis configuration

5. **Expected Results**
   - Estimated performance improvement (%)
   - Resource usage reduction
   - Scalability benefits

6. **Implementation Steps**
   - Order of changes to implement
   - Testing approach
   - Rollback plan

7. **Monitoring**
   - Performance metrics to track
   - Query insights to monitor
   - Alert thresholds
```

---

## For Database Indexing Strategy

```
Help me design database indexing for performance:

**Current Situation:**
- Database: [Azure SQL/PostgreSQL]
- Total records: [millions/billions]
- Daily queries: [number]
- Write operations: [read/write ratio]

**Slow Queries:** (list top 5)
1. [Query description with execution time]
2. [Query description with execution time]
3. [Query description with execution time]
4. [Query description with execution time]
5. [Query description with execution time]

**Table Schema:**
[Paste table definitions or entity configuration]

**Current Indexes:**
[List existing indexes if known]

**Constraints:**
- Read-heavy / Write-heavy / Balanced?
- Concurrent users: [number]
- Storage budget: [GB]
- Maintenance window: [available time]

Provide:
1. **Index Analysis**
   - Which queries would benefit from indexes
   - Recommended index combinations
   - Covering indexes for frequent queries

2. **Index Creation Scripts**
   - SQL for creating recommended indexes
   - Clustered vs non-clustered decision
   - Included columns strategy

3. **Impact Assessment**
   - Write operation impact
   - Storage overhead
   - Maintenance cost

4. **Implementation Plan**
   - Index creation order
   - Online index creation during business hours
   - Statistics update strategy

5. **Monitoring**
   - Performance baselines
   - Index usage tracking
   - Index fragmentation monitoring
```

---

## For Caching Strategy Design

```
Design optimal caching strategy for my application:

**Current State:**
- Database response time: [ms]
- Target response time: [ms]
- Database load: [queries/sec]
- Peak traffic: [requests/sec]

**Cacheable Data:**
1. [Type of data] - Update frequency: [minutes/hours]
2. [Type of data] - Update frequency: [minutes/hours]
3. [Type of data] - Update frequency: [minutes/hours]

**Cache Technology:**
- Azure Cache for Redis: [Yes/No]
- In-Memory cache: [Yes/No]
- Distributed cache needed: [Yes/No]

**Current Performance Issues:**
[Describe specific slowness]

**Constraints:**
- Maximum cache size: [GB]
- Consistency requirement: [Strong/Eventual]
- TTL tolerance: [seconds/minutes]

Recommend:
1. **Cache Architecture**
   - Cache-aside vs write-through pattern
   - Local vs distributed caching
   - Multi-tier caching approach

2. **Caching Policies**
   - Time-to-Live (TTL) for each data type
   - Eviction policies (LRU, FIFO, etc.)
   - Cache warming strategy

3. **Implementation Code**
   - Cache service interface
   - Decorator pattern for automatic caching
   - Cache invalidation logic

4. **Performance Impact**
   - Expected latency improvement
   - Hit rate expectations
   - Memory requirements

5. **Monitoring**
   - Cache hit/miss ratio
   - Eviction rate
   - Memory usage
   - Application response time trends

6. **Invalidation Strategy**
   - Event-driven invalidation
   - Time-based expiration
   - Manual cache clearing triggers
```

---

## For Async/Await Performance

```
Optimize this async code for performance:

**Current Implementation:**
[Paste async method or controller action]

**Performance Baseline:**
- Current response time: [ms]
- Target response time: [ms]
- Concurrent requests: [number]
- Database time: [ms]
- API calls time: [ms]

**Call Graph:**
[Describe what this code calls - other services, databases, etc.]

**Resource Constraints:**
- Thread pool size: [if known]
- Connection pool size: [if known]
- Memory limit: [if applicable]

**Issues Noticed:**
[Describe any async concerns]

Analyze and provide:
1. **Concurrency Analysis**
   - Are operations truly parallel?
   - Unnecessary sequential calls
   - Blocking operations identified

2. **Optimized Code**
   - Using Task.WhenAll for parallelism
   - Proper ConfigureAwait usage
   - Removing sync-over-async patterns

3. **Resource Optimization**
   - Connection pooling efficiency
   - HttpClient usage
   - Memory allocation

4. **Performance Gains**
   - Expected improvement
   - Resource utilization change
   - Scalability improvements

5. **Testing Strategy**
   - Load testing approach
   - Performance regression tests
   - Stress testing scenarios
```

---

## For Load Testing & Capacity Planning

```
Help me design load testing for this service:

**Service:**
[Microservice/API name and purpose]

**Expected Load:**
- Daily active users: [number]
- Peak concurrent users: [number]
- Requests per second (peak): [number]
- Growth rate: [%/month or /year]

**Critical Operations:**
1. [Operation] - Frequency: [times/second]
2. [Operation] - Frequency: [times/second]
3. [Operation] - Frequency: [times/second]

**Current Performance:**
- Response time: [ms]
- Database time: [ms]
- API calls time: [ms]
- Error rate: [%]

**Infrastructure:**
- Current: [# of nodes/cores/memory]
- Target scaling: [horizontal/vertical/both]
- Cloud: [Azure AKS/App Service]

**SLO Requirements:**
- 99th percentile latency: [ms]
- 95th percentile latency: [ms]
- Availability target: [%]

Provide:
1. **Load Test Scenarios**
   - Ramp-up strategy (gradual load increase)
   - Steady-state test profile
   - Spike/burst scenarios
   - Soak testing (long-running)

2. **Test Metrics**
   - Response time distribution
   - Throughput (requests/sec)
   - Error rates by type
   - Resource utilization

3. **Capacity Calculations**
   - Resources needed for SLO
   - Headroom for spikes (20%?)
   - Scaling triggers
   - Cost estimation

4. **Testing Tools & Scripts**
   - Load testing tool recommendation (k6, JMeter, NBomber)
   - Test scenario code
   - Performance baselines

5. **Monitoring During Test**
   - Application metrics to track
   - Infrastructure metrics
   - Database metrics
   - Network saturation points

6. **Bottleneck Analysis**
   - Where do failures occur under load?
   - Resource bottlenecks
   - Database contention
   - Network limits

7. **Optimization Priorities**
   - Based on test results
   - Quick wins vs major refactoring
   - Cost vs performance trade-offs
```

---

## For Memory Profiling & Optimization

```
Help me optimize memory usage in this service:

**Current Situation:**
- Memory usage (baseline): [MB]
- Memory usage (peak): [MB]
- Memory leak suspected: [Yes/No]
- Garbage collection pause time: [ms]

**Workload:**
- Requests per second: [number]
- Data processed per request: [KB/MB]
- Object allocation rate: [objects/sec]

**Code Sample:**
[Paste classes or methods suspected of high memory usage]

**Memory Profiler Results:** (if available)
[Paste memory profiler snapshot or report]

**Constraints:**
- Container memory limit: [MB]
- Acceptable GC pause time: [ms]
- Environment: [Development/Production]

Analyze and recommend:
1. **Memory Hotspots**
   - Objects being over-allocated
   - String allocations & concatenation issues
   - Collection size problems
   - Caching inefficiencies

2. **Optimization Strategies**
   - Object pooling for frequently allocated types
   - StringBuilder for string building
   - LINQ to Objects vs IEnumerable
   - Span<T> and stackalloc where applicable

3. **Garbage Collection Tuning**
   - GC mode (workstation vs server)
   - TIERED compilation
   - Heap size tuning
   - GC pressure reduction

4. **Refactored Code**
   - Optimized implementation
   - Alternative approaches
   - Performance annotations (if relevant)

5. **Testing & Validation**
   - Memory benchmarking
   - Heap dump analysis
   - Stress testing
   - Long-running stability tests

6. **Monitoring**
   - Memory usage metrics
   - GC frequency & pause times
   - Gen 2 collection pressure
   - OutOfMemory prediction
```

---

Use these templates to get detailed, actionable performance optimization guidance from Claude.
