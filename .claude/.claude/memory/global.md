# Global Project Context

## Project Type
Full-stack enterprise application with:
- .NET Clean Architecture backend (microservices-ready)
- Angular v20+ SPA frontend
- SQL Server (primary) + PostgreSQL (secondary) + Redis (cache)
- Azure cloud infrastructure

## Architecture Decisions
- Clean Architecture with strict layer separation (no Infrastructure → Domain shortcuts)
- CQRS via MediatR — Commands mutate, Queries project
- Signals for frontend state — minimal RxJS (HTTP only)
- Cache-aside pattern with Redis for hot data
- Azure Key Vault for all secrets (no config file secrets)

## Team Conventions
- C# naming: PascalCase for types/methods, _camelCase for private fields
- Angular naming: kebab-case filenames, PascalCase classes
- Git: conventional commits (`feat:`, `fix:`, `chore:`, `docs:`)
- PR: require 1 reviewer + passing CI before merge
- Test coverage target: 80% for Domain + Application layers

## Current Sprint / Focus
<!-- Update this section each sprint -->
- Feature: [Current feature name]
- Priority: [High/Medium/Low]
- Deadline: [Date]
- Blockers: [Any blockers]

## Key Contacts
- Architect: [Name]
- Backend Lead: [Name]
- Frontend Lead: [Name]
- DevOps: [Name]

## Important Links
- Azure Portal: [link]
- Azure DevOps: [link]
- Jira/Linear: [link]
- App Insights: [link]
