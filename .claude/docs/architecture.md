# System Architecture

## Overview

Full-stack enterprise application with:
- **Backend**: .NET 10 Clean Architecture API (REST)
- **Frontend**: Angular 20 SPA
- **Primary DB**: SQL Server (EF Core)
- **Secondary DB**: PostgreSQL (EF Core, optional per service)
- **Cache**: Redis (StackExchange.Redis)
- **Cloud**: Azure (AKS / App Service)

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                      Azure                               │
│                                                           │
│  ┌──────────────┐     ┌─────────────────────────────┐   │
│  │  Azure CDN   │────▶│  Angular SPA (Static Web    │   │
│  │  / Front Door│     │  Apps / Azure Storage)      │   │
│  └──────────────┘     └─────────────────────────────┘   │
│                                        │ HTTP/HTTPS       │
│                              ┌─────────▼─────────┐       │
│                              │  API Management    │       │
│                              │  (rate limit, auth)│       │
│                              └─────────┬─────────┘       │
│                                        │                  │
│  ┌──────────────────────────────────── ▼ ──────────────┐ │
│  │          AKS / App Service                           │ │
│  │  ┌──────────────┐  ┌──────────────┐                 │ │
│  │  │  Service A   │  │  Service B   │  ...             │ │
│  │  │  (.NET API)  │  │  (.NET API)  │                 │ │
│  │  └──────┬───────┘  └──────┬───────┘                 │ │
│  └─────────┼─────────────────┼───────────────────────┘  │
│            │                 │                           │
│  ┌─────────▼─────────────────▼───────────────────────┐  │
│  │              Azure Service Bus                      │  │
│  │         (async messaging between services)         │  │
│  └────────────────────────────────────────────────────┘  │
│            │                 │                           │
│  ┌─────────▼──────┐  ┌──────▼─────────┐  ┌──────────┐  │
│  │  Azure SQL     │  │  PostgreSQL     │  │  Redis   │  │
│  │  (SQL Server)  │  │  (Azure DB PG)  │  │  Cache   │  │
│  └────────────────┘  └────────────────┘  └──────────┘  │
│                                                           │
│  ┌───────────┐  ┌───────────────┐  ┌───────────────────┐ │
│  │ Key Vault │  │ App Insights  │  │  Azure AD / Entra │ │
│  └───────────┘  └───────────────┘  └───────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

## Backend Layer Architecture (per service)

```
WebApi (entry point)
  └── Application (use cases / CQRS)
        └── Domain (business logic)
Infrastructure (cross-cutting: DB, cache, external)
  └── Application interfaces
```

| Layer | Responsibility | Key Technologies |
|-------|----------------|------------------|
| Domain | Entities, Value Objects, Domain Events, Business Rules | Pure C# |
| Application | Commands, Queries, DTOs, Validators, Behaviors | MediatR, FluentValidation |
| Infrastructure | EF Core repos, Redis, HTTP clients, messaging | EF Core, StackExchange.Redis |
| WebApi | REST endpoints, Auth, Middleware, DI | ASP.NET Core 9 |

---

## Frontend Architecture (Angular 20)

```
src/app/
├── core/                    # Singleton services, auth, interceptors, guards
│   ├── auth/
│   ├── interceptors/
│   └── guards/
├── shared/                  # Reusable components, pipes, directives
│   ├── components/
│   ├── pipes/
│   └── directives/
├── features/                # Feature modules (lazy-loaded)
│   ├── feature-a/
│   │   ├── pages/           # Smart components (route-level)
│   │   ├── components/      # Dumb components (display only)
│   │   ├── services/        # Feature-specific services
│   │   └── models/          # Interfaces and types
│   └── feature-b/
└── layouts/                 # App shell layouts
```

---

## Data Flow

### Command (Write)
```
HTTP POST /api/resource
  → Controller validates HTTP request
  → Sends Command via MediatR
  → Validation Behavior (FluentValidation)
  → Command Handler (business logic)
  → Domain entity updated, domain event raised
  → Repository saves (EF Core)
  → UnitOfWork commits
  → Domain events published (MediatR notifications)
  → Cache invalidated
  → HTTP 201 Created
```

### Query (Read)
```
HTTP GET /api/resource
  → Controller
  → Sends Query via MediatR
  → Query Handler
  → Check Redis cache → HIT: return cached DTO
  → MISS: EF Core projection query
  → Store in Redis with TTL
  → Return DTO
  → HTTP 200 OK
```

---

## Cross-Cutting Concerns

| Concern | Implementation |
|---------|----------------|
| Authentication | Azure AD / Entra ID (JWT Bearer) |
| Authorization | Claims-based policies |
| Logging | Serilog → Application Insights |
| Tracing | OpenTelemetry → Application Insights |
| Secrets | Azure Key Vault (Managed Identity) |
| Health | ASP.NET Core Health Checks → AKS probes |
| Resilience | Polly (retry, circuit breaker) |
| Caching | Redis (distributed), IMemoryCache (in-process) |
