---
name: software-architecture
description: >
  Compare architectural styles, service boundaries, layering approaches, and system-level tradeoffs. Use when the user asks about monoliths versus services, modular boundaries, domain seams, integration styles, or how to structure a system for growth and maintainability.
---

# Software Architecture

Use this skill to reason about high-level structure, boundaries, and system tradeoffs.

## Intent Router

| Need | Load |
| --- | --- |
| Architecture options and evaluation criteria | `references/architecture-checklist.md` |

## Quick Reference

1. Start with system goals, constraints, and expected rate of change.
2. Choose boundaries around business capability and dependency direction.
3. Optimize for clarity of ownership before optimizing for distribution.
4. Treat operational complexity as a first-class tradeoff.

## Evaluation Pattern

- State the primary drivers: scale, team topology, deploy cadence, reliability, compliance.
- Compare two or three candidate structures.
- Recommend the simplest structure that satisfies the current drivers.
- Note what future signals would justify evolving the architecture.

## Safety Notes

- Avoid distributed systems when a modular monolith will do.
- Avoid vague "future-proofing" without a concrete likely change.
