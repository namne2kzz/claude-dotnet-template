# Runbook: Incident Response

Procedure for handling production incidents.

## Severity Levels

| Level | Description | Response Time | Examples |
|-------|-------------|---------------|---------|
| P1 — Critical | Service completely down | 15 min | All APIs returning 500, DB unreachable |
| P2 — High | Core feature broken | 1 hour | Login failing, payment errors |
| P3 — Medium | Non-critical feature broken | 4 hours | Report generation failing |
| P4 — Low | Minor issue | Next business day | Cosmetic UI bug |

---

## P1/P2 Response Procedure

### 1. Acknowledge (< 5 min)
```
- Alert received via PagerDuty / Application Insights alert
- Acknowledge alert
- Post in #incidents Slack channel:
  "[INCIDENT] P[N] — [Brief description] — Investigating — @[on-call]"
```

### 2. Diagnose (< 15 min)

#### Check Application Insights
```kusto
// Recent errors
exceptions
| where timestamp > ago(30m)
| summarize count() by outerMessage, type
| order by count_ desc
| take 20

// Slow requests
requests
| where timestamp > ago(30m) and duration > 1000
| summarize count(), avg(duration) by name
| order by count_ desc
```

#### Check Azure SQL
```sql
-- Active blocking queries
SELECT
    blocking_session_id,
    wait_type, wait_time,
    substring(st.text, 1, 200) AS sql_text
FROM sys.dm_exec_requests
CROSS APPLY sys.dm_exec_sql_text(sql_handle) st
WHERE blocking_session_id > 0;

-- Resource pressure
SELECT TOP 10 *
FROM sys.dm_exec_query_stats
ORDER BY total_elapsed_time DESC;
```

#### Check Redis
```bash
redis-cli INFO stats | grep -E "hit_rate|evicted_keys|blocked_clients"
redis-cli INFO memory | grep used_memory_human
```

#### Check AKS
```bash
kubectl get pods -n {namespace}
kubectl describe pod {failing-pod} -n {namespace}
kubectl logs {failing-pod} -n {namespace} --tail=100
```

### 3. Mitigate (immediate relief)

**Option A: Rollback deployment** (if caused by recent deploy)
```bash
kubectl rollout undo deployment/{app-name} -n {namespace}
```

**Option B: Scale up** (if capacity issue)
```bash
kubectl scale deployment/{app-name} --replicas=5 -n {namespace}
```

**Option C: Disable feature flag** (if specific feature causing issue)
```
Toggle feature flag in Azure App Config or code
```

**Option D: Redis flush** (if cache corruption suspected)
```bash
redis-cli FLUSHDB  # ⚠️ only if sure cache is the issue!
```

### 4. Communicate

**Status update every 30 min:**
```
[INCIDENT UPDATE] P[N] — [description]
Status: [Investigating | Mitigated | Resolved]
Impact: [Who is affected, how many users]
ETA: [Estimated resolution time]
Actions taken: [List]
```

### 5. Resolve
```
[INCIDENT RESOLVED] P[N] — [description]
Duration: [X hours Y minutes]
Root cause: [brief]
Fix applied: [brief]
Post-mortem: [link or "TBD — within 5 days"]
```

---

## Post-Mortem Template

```markdown
## Post-Mortem: [Incident Title]

**Date**: [Date]
**Duration**: [Start] → [End] = [X hours]
**Severity**: P[N]
**Impact**: [Users affected, business impact]

### Timeline
| Time | Event |
|------|-------|
| HH:MM | Alert triggered |
| HH:MM | On-call acknowledged |
| HH:MM | Root cause identified |
| HH:MM | Mitigation applied |
| HH:MM | Incident resolved |

### Root Cause
[Single clear sentence explaining why this happened]

### Contributing Factors
- [Factor 1]
- [Factor 2]

### What Went Well
- [Positive 1]

### What Went Wrong
- [Issue 1]

### Action Items
| Action | Owner | Due Date |
|--------|-------|----------|
| [Preventive measure] | [Name] | [Date] |
| [Monitoring improvement] | [Name] | [Date] |
```
