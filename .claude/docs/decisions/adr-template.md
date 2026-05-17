# ADR-[NNN]: [Short Title]

**Date**: [YYYY-MM-DD]
**Status**: [Proposed | Accepted | Deprecated | Superseded by ADR-NNN]
**Deciders**: [List of people involved]

---

## Context

[Describe the issue or problem. What is the technical/business context? What forces are at play? Why does a decision need to be made now?]

---

## Decision Drivers

- [Driver 1: e.g., performance requirement < 50ms]
- [Driver 2: e.g., team familiarity with technology]
- [Driver 3: e.g., cost constraint]

---

## Considered Options

### Option 1: [Name]
[Brief description]
- **Pros**: [advantages]
- **Cons**: [disadvantages]

### Option 2: [Name]
[Brief description]
- **Pros**: [advantages]
- **Cons**: [disadvantages]

### Option 3: [Name]
[Brief description]
- **Pros**: [advantages]
- **Cons**: [disadvantages]

---

## Decision

**Chosen option**: Option [N] — [Name]

**Rationale**: [Why was this option chosen over the others? What specific drivers led to this choice?]

---

## Consequences

### Positive
- [Good outcome 1]
- [Good outcome 2]

### Negative / Trade-offs
- [Bad outcome or trade-off 1]
- [Mitigation strategy]

### Neutral
- [Side effect that is neither good nor bad]

---

## Implementation Notes

[Any specific notes on how to implement this decision, configuration required, or migration path]

---

## Related Decisions
- ADR-[NNN]: [Related decision]

---

## Example ADRs (delete this section in real ADRs)

### Example: ADR-001: Use Redis for distributed caching
- Context: Multiple API instances need shared session/cache state
- Decision: Redis (StackExchange.Redis) with IDistributedCache abstraction
- Rationale: Industry standard, Azure Cache for Redis available, team familiarity
- Consequence: Operations must manage Redis instance; adds infrastructure complexity

### Example: ADR-002: Use Signals over NgRx for Angular state
- Context: Angular app needs reactive state management
- Decision: Angular Signals (built-in) over NgRx
- Rationale: No extra dependencies, simpler mental model for team, sufficient for app complexity
- Consequence: Less tooling (no Redux DevTools), may need to revisit for very complex state
