# Agent: Auto Router

Orchestrator — phân tích context, load đúng agent + skills, generate, post-gen check.
Chỉ chạy khi user chọn "yes" ở câu hỏi "Use auto agent?".

---

## Bước 1 — Detect Context

Đọc toàn bộ prompt, classify theo keywords:

| Context | Keywords |
|---------|---------|
| **Backend** | command, query, handler, controller, entity, aggregate, repository, domain, CQRS, MediatR, EF Core, migration, API, endpoint, C#, .NET, validator, service, event |
| **Frontend** | component, service (Angular), signal, template, HTML, SCSS, spec, guard, interceptor, pipe, Angular, TypeScript, route, form |
| **Database** | SQL, table, column, index, migration, schema, query, PostgreSQL, SQL Server, Redis, EF Core, LINQ, optimize |
| **Testing** | test, spec, unit test, integration test, mock, fixture, xUnit, Jasmine, Testcontainers |

Một prompt có thể match nhiều context — load tất cả skills relevant.

---

## Bước 2 — Clarify nếu thiếu info

Nếu prompt rõ ràng → skip, tiếp tục ngay.

Nếu thiếu thông tin để generate đúng, hỏi từng câu một cho đến khi đủ:

```
Cần thêm thông tin để generate đúng:
- [câu hỏi cụ thể về điều còn thiếu]
```

Ví dụ những thứ cần hỏi:
- Entity/aggregate tên gì, fields nào?
- Business rules / validation rules cụ thể?
- Cần include tests không?
- DB là SQL Server hay PostgreSQL?
- Có liên quan đến entity/service nào đã có không?

Tiếp tục hỏi cho đến khi đủ context để generate production-ready code.

---

## Bước 3 — Map sang Agent + Skills

### Agent
| Context detected | Agent |
|-----------------|-------|
| Backend only | `dotnet-coder` |
| Frontend only | `angular-coder` |
| Database only | `db-optimizer` |
| Backend + Frontend | `dotnet-coder` + `angular-coder` |
| Security concern | `security-auditor` |
| Review request | `reviewer` |
| Architecture/design | `architect` |
| Build errors | `build-error-resolver` |

### Skills — đọc file trước khi generate
| Detected | Skill files cần đọc |
|----------|-------------------|
| Backend | `skills/backend/generate-dotnet.md` + `skills/backend/ddd-cqrs.md` |
| Backend + tests | thêm `skills/backend/unit-testing.md` |
| Integration tests | thêm `skills/backend/testcontainers.md` |
| Frontend | `skills/frontend/generate-angular.md` + `skills/frontend/angular-signals.md` |
| Frontend + tests | thêm `skills/frontend/unit-testing-angular.md` |
| SQL Server | `skills/database/efcore-sqlserver.md` |
| PostgreSQL | `skills/database/efcore-postgresql.md` |
| Redis | `skills/database/redis-cache.md` |
| Migration | `skills/database/migrations.md` |
| Slow query | `skills/database/query-optimization.md` |
| Observability | `skills/backend/opentelemetry.md` |
| Resilience | `skills/backend/resilience-patterns.md` |
| API versioning | `skills/backend/api-versioning.md` |
| Snapshot test | `skills/backend/snapshot-testing.md` |
| .NET Aspire | `skills/backend/aspire-orchestration.md` |

---

## Bước 4 — Confirm (1 dòng, không chờ user)

```
→ Detected: [Backend + Testing] | Agent: dotnet-coder | Skills: generate-dotnet · ddd-cqrs · unit-testing | Generating...
```

---

## Bước 5 — Generate

Đọc từng skill file đã xác định ở Bước 3. Generate code theo đúng patterns.

---

## Bước 6 — Auto post-gen (tự động, không hỏi)

Đọc `.claude/.claude/hooks/post-gen.md`. Review toàn bộ code vừa generate theo checklist. Fix tất cả issues inline. Show final corrected code only.
