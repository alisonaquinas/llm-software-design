# Coupling guide

## What low coupling means

Low coupling reduces the strength and breadth of dependencies so changes remain local, testable, and deployable without wide ripple effects. The goal is not zero dependency; the goal is explicit, narrow, and stable dependency where it belongs.

## Forms of coupling to check

### Structural coupling

- imports, calls, field access, inheritance chains, and dependency cycles
- stable packages depending on volatile details
- high fan-out components that become change magnets

### Contract and schema coupling

- breaking API changes
- shared schemas with unclear ownership
- many consumers depending on details that should stay private

### Temporal and coordination coupling

- long synchronous chains
- must-deploy-together components
- workflows that require simultaneous changes across teams

### Shared-state and operational coupling

- shared databases, global state, ambient context, and hidden configuration coupling
- event-driven flows without schema discipline, tracing, or idempotency rules
- incidents that spread because ownership and dependency boundaries are unclear

## Reduction moves

- hide volatile details behind stable interfaces
- invert dependencies so policy does not depend directly on infrastructure
- break cycles before introducing larger architectural change
- isolate shared data ownership and make contracts explicit
- use asynchronous integration only when the consistency and observability tradeoffs are acceptable
- focus first on central hotspots and repeated co-change clusters

## Measurement signals

- package or module cycles
- afferent and efferent coupling
- instability trends
- architecture centrality or propagation cost
- logical coupling from version-control co-change
- deployment coordination count for one feature or fix

## Review checklist

- [ ] the dominant coupling type is named explicitly
- [ ] one concrete ripple effect is identified
- [ ] the proposed seam lowers coordination cost, not only code distance
- [ ] contract and runtime consequences are addressed
- [ ] success can be checked with at least one before-and-after signal
