# Full-Stack .NET + Angular + DB — Claude Code Template

A production-ready Claude Code template for full-stack developers working with:
- **Backend**: .NET 10, Clean Architecture, DDD, CQRS
- **Frontend**: Angular 20 (Signals, Standalone, @if/@for)
- **Database**: SQL Server + PostgreSQL (EF Core) + Redis

---

## Quick Start

1. **Read `CLAUDE.md`** — master instructions, loaded automatically by Claude Code
2. **Configure `.claude/config.json`** — set your project name, paths, stack versions
3. **Update `.claude/memory/global.md`** — fill in your project context
4. **Use skills** — e.g., `/generate-angular`, `/ddd-cqrs`, `/efcore-sqlserver`
5. **Follow workflows** — e.g., `/workflow build-feature`

---

## Structure

```
claude-dotnet-template/
├── CLAUDE.md                    ← Master instructions (always loaded)
├── ROADMAP.md                   ← Planned improvements
├── CHANGELOG.md                 ← What changed
│
├── .claude/
│   ├── config.json              ← Stack config, model settings
│   ├── memory/
│   │   ├── global.md            ← Project context (update per project)
│   │   ├── patterns.md          ← Established code patterns
│   │   └── mistakes.md          ← Anti-patterns to avoid
│   ├── skills/
│   │   ├── backend/             ← .NET skills (generate, clean-arch, ddd-cqrs)
│   │   ├── frontend/            ← Angular v20+ skills (generate, signals, rxjs)
│   │   └── database/            ← DB skills (SQL Server, PostgreSQL, Redis, migrations)
│   ├── agents/                  ← Specialized agent personas
│   ├── workflows/               ← End-to-end feature workflows
│   └── hooks/                   ← Pre/post generation checks
│
├── docs/
│   ├── architecture.md          ← System architecture overview
│   ├── decisions/               ← Architecture Decision Records
│   └── runbooks/                ← Deployment & incident response
│
├── prompts/
│   ├── system/                  ← System prompt for Claude custom instructions
│   └── tasks/                   ← Task-specific prompt templates
│
├── tools/
│   ├── scripts/                 ← PowerShell setup scripts
│   ├── pipelines/               ← Azure DevOps + GitHub Actions CI/CD
│   └── evals/                   ← AI output quality criteria
│
├── templates/
│   ├── dotnet/                  ← .NET C# code templates
│   ├── angular/                 ← Angular v20+ templates (separate .ts/.html/.scss/.spec)
│   └── infrastructure/          ← K8s, Terraform templates
│
├── examples/
│   ├── c-sharp/                 ← .NET code examples (DDD aggregates, CQRS)
│   └── typescript/              ← Angular v20+ examples (Signals, interceptors)
│       └── models/              ← Model interfaces (separate from logic files)
│
├── projects/                    ← Actual project source (backend, frontend, infra, devops)
│
└── experiments/                 ← Sandbox for trying ideas
```

---

## Skills Reference

### Backend
| Skill | File | Use For |
|-------|------|---------|
| `/generate-dotnet` | `.claude/skills/backend/generate-dotnet.md` | Generate entities, commands, queries, controllers |
| `/clean-architecture` | `.claude/skills/backend/clean-architecture.md` | Review/fix layer violations |
| `/ddd-cqrs` | `.claude/skills/backend/ddd-cqrs.md` | Design aggregates, events, sagas |
| `/unit-testing` | `.claude/skills/backend/unit-testing.md` | xUnit + Moq + FluentAssertions + Bogus patterns |

### Frontend (Angular v20+)
| Skill | File | Use For |
|-------|------|---------|
| `/generate-angular` | `.claude/skills/frontend/generate-angular.md` | Generate components, services, stores |
| `/angular-signals` | `.claude/skills/frontend/angular-signals.md` | Signal patterns, convert BehaviorSubject |
| `/angular-rxjs` | `.claude/skills/frontend/angular-rxjs.md` | RxJS HTTP patterns, operator selection |
| `/unit-testing-angular` | `.claude/skills/frontend/unit-testing-angular.md` | Jasmine + TestBed + signal mocking |

### Database
| Skill | File | Use For |
|-------|------|---------|
| `/efcore-sqlserver` | `.claude/skills/database/efcore-sqlserver.md` | SQL Server queries, indexes, config |
| `/efcore-postgresql` | `.claude/skills/database/efcore-postgresql.md` | PostgreSQL, JSONB, full-text search |
| `/redis-cache` | `.claude/skills/database/redis-cache.md` | Cache strategy, TTL, invalidation |
| `/migrations` | `.claude/skills/database/migrations.md` | Safe migration strategy |
| `/query-optimization` | `.claude/skills/database/query-optimization.md` | Diagnose slow queries |

### Agents
| Agent | Use For |
|-------|---------|
| `[dotnet-coder]` | .NET code generation |
| `[angular-coder]` | Angular v20+ code generation |
| `[reviewer]` | Full-stack code review |
| `[architect]` | Feature/system design |
| `[db-optimizer]` | DB performance diagnosis |

### Workflows
| Workflow | Use For |
|----------|---------|
| `/workflow build-feature` | Full-stack feature from scratch |
| `/workflow fix-bug` | Systematic bug investigation |
| `/workflow code-review` | PR/code review |
| `/workflow deploy-to-azure` | Deployment checklist + pipeline |

---

## Daily Workflow

### Setup — Tích hợp vào project của bạn

**Bước 1 — Copy 2 thứ vào root solution (nơi bạn chạy `claude`):**

```
YourSolution/
├── CLAUDE.md                    ← copy từ template, auto-load khi mở claude
├── .claude/                     ← copy từ template (skills, agents, memory...)
│
│   ← code project của bạn đặt dưới đây, cùng cấp với CLAUDE.md
│
├── src/                         ← .NET backend
│   ├── YourApp.Domain/
│   │   ├── Entities/
│   │   ├── Events/
│   │   └── Interfaces/
│   ├── YourApp.Application/
│   │   └── Orders/
│   │       ├── Commands/        ← CreateOrderCommand.cs + Handler + Validator
│   │       ├── Queries/         ← GetOrderByIdQuery.cs + Handler
│   │       └── DTOs/            ← OrderDto.cs
│   ├── YourApp.Infrastructure/
│   │   ├── Persistence/         ← AppDbContext, Repositories, Configurations/
│   │   └── Services/            ← EmailService, RedisCache, etc.
│   └── YourApp.WebApi/
│       ├── Controllers/
│       │   └── Orders/
│       │       ├── OrdersController.cs
│       │       └── Requests/    ← CreateOrderRequest.cs (tách khỏi controller)
│       └── Middleware/
│
├── tests/
│   ├── Unit/                    ← xUnit + Moq + FluentAssertions + Bogus
│   │   └── Orders/
│   │       └── CreateOrderCommandHandlerTests.cs
│   └── Integration/
│
├── YourApp.sln
│
├── frontend/                    ← Angular project
│   ├── src/
│   │   └── app/
│   │       ├── core/            ← auth, interceptors, guards
│   │       ├── shared/          ← reusable components, pipes, directives
│   │       ├── features/
│   │       │   └── orders/      ← mỗi feature = 1 folder
│   │       │       ├── pages/
│   │       │       │   ├── order-list/
│   │       │       │   │   ├── order-list.component.ts
│   │       │       │   │   ├── order-list.component.html
│   │       │       │   │   ├── order-list.component.scss
│   │       │       │   │   └── order-list.component.spec.ts
│   │       │       │   └── order-detail/
│   │       │       ├── components/  ← dumb/presentational components
│   │       │       ├── services/
│   │       │       │   ├── order.service.ts
│   │       │       │   └── order.service.spec.ts
│   │       │       └── models/      ← order.model.ts (interfaces ở đây)
│   │       └── layouts/
│   ├── tests/
│   │   └── builders/            ← order.builder.ts, customer.builder.ts
│   ├── angular.json
│   └── package.json
│
└── infrastructure/              ← IaC
    ├── k8s/
    └── terraform/
```

**Bước 2 — Sau khi copy, update 2 file này cho đúng project:**

| File | Update gì |
|------|-----------|
| `CLAUDE.md` → **Project Structure** | Đổi namespace `YourApp` → tên app thực tế |
| `.claude/memory/global.md` | Điền project context, sprint hiện tại, links |

> `CHANGELOG.md`, `README.md`, `ROADMAP.md`, `templates/`, `docs/` — giữ trong folder template để tham khảo, không cần copy sang.

---

### Generate + Auto-Review — 1 Prompt Duy Nhất

Sau khi nhận code từ Claude, không cần prompt review riêng. Gộp vào ngay trong lúc generate:

```
[agent] [yêu cầu của bạn]

After generating, verify against .claude/hooks/post-gen.md. Fix all failures inline. Show final code only.
```

**Ví dụ thực tế — Backend:**
```
[dotnet-coder] Generate CreateOrderCommand:
- Entity: Order (CustomerId, Note, Items)
- Deps: IOrderRepository, ICustomerRepository, IUnitOfWork
- Validation: CustomerId required, Items not empty
- Return: Result<Guid>
- Include unit tests

After generating, verify against .claude/hooks/post-gen.md. Fix all failures inline. Show final code only.
```

**Ví dụ thực tế — Frontend:**
```
[angular-coder] Generate OrderListPage:
- Loads orders from OrderService (GET /api/orders)
- Shows loading / error / empty / loaded states
- Click row → navigate to /orders/:id
- Separate .ts / .html / .scss / .spec.ts files

After generating, verify against .claude/hooks/post-gen.md. Fix all failures inline. Show final code only.
```

> **Tại sao cách này tối ưu:** `post-gen.md` cover toàn bộ — architecture, memory management, SOLID, docs, security, tests. "Fix inline" loại bỏ round trip. "Show final code only" tiết kiệm token output.

---

### Full-Stack Feature — End-to-End

Dùng workflow có sẵn cho feature lớn cần design trước:

```
/workflow build-feature [mô tả feature]
```

Workflow đi qua 6 bước: architect → DB schema → backend CQRS → API controller → Angular frontend → review.

---

## Conventions (Non-negotiable)

### Angular
- Components: always `standalone: true`, separate `.ts` / `.html` / `.scss` / `.spec.ts`
- Interfaces: always in separate `models/*.model.ts` files
- State: `signal()` / `computed()` — no inline `BehaviorSubject` in components
- Template: `@if` / `@for` / `@defer` — never `*ngIf` / `*ngFor`
- DI: `inject()` — never constructor injection

### .NET
- Request/Response records: separate `Requests/` and `DTOs/` files — never inside Controller
- Domain logic: in Domain entities and domain services — never in Application handlers or controllers
- Async: always `async/await` with `CancellationToken ct = default` — no `.Result`/`.Wait()`

---

## System Prompt Setup

Copy `prompts/system/expert-fullstack.md` content into Claude's **Custom Instructions** for expert-level responses across all conversations.
