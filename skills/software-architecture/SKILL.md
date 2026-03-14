---
name: software-architecture
description: >
  compare architectural styles, service boundaries, layering approaches, and system-level tradeoffs. use when the user asks about monoliths versus services, modular boundaries, domain seams, integration styles, or how to structure a system for growth and maintainability.
---

# Software Architecture

Use this skill to reason about high-level structure, boundaries, and system tradeoffs.

## Intent Router

| Need | Load |
| --- | --- |
| architectural drivers, boundary heuristics, and review checklist | `references/architecture-checklist.md` |

## Quick Start

1. Start with system goals, constraints, and expected rate of change.
2. Choose boundaries around business capability, ownership, and dependency direction.
3. Optimize for clarity of responsibility before optimizing for distribution.
4. Treat operational complexity as a first-class tradeoff.

## Workflow

- state the primary drivers: scale, team topology, deploy cadence, reliability, compliance, and data shape
- compare two or three plausible structures rather than jumping to one favored style
- identify what must change, fail, or deploy independently
- recommend the simplest structure that satisfies the current drivers
- note which future signals would justify evolving the architecture

## Outputs to Prefer

- explain the recommendation in terms of boundaries, ownership, data flow, and operational cost
- make coupling, latency, consistency, and failure-mode tradeoffs explicit
- distinguish current needs from hypothetical future-proofing
- recommend migration steps when the architecture should evolve incrementally

## Common Requests

```text
Compare a modular monolith and services for this system and recommend boundaries.
```

```text
Review this architecture for boundary clarity, integration risk, and unnecessary distribution.
```

## Safety Notes

- avoid distributed systems when a modular monolith will do
- avoid vague future-proofing without a concrete likely change
- do not recommend service boundaries that exceed the team's operational maturity
