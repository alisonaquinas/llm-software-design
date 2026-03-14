---
name: oop
description: >
  reason about object-oriented modeling, responsibilities, collaborations, and object boundaries. use when the user asks how to model a domain with objects, distribute behavior, choose between objects and procedures, or improve cohesion and collaboration in an object-oriented design.
---

# OOP

Use this skill to reason about object modeling, responsibility placement, and collaboration design.

## Intent Router

| Need | Load |
| --- | --- |
| modeling heuristics, collaboration questions, and review checklist | `references/modeling.md` |

## Quick Start

1. Identify the domain concepts, invariants, and lifecycle boundaries first.
2. Place behavior near the data and invariants it must protect.
3. Model collaborations explicitly when multiple objects must coordinate to fulfill one use case.
4. Prefer simple objects with clear responsibilities over deep hierarchies or procedural wrappers around data bags.

## Workflow

- name the core domain concepts and what each one must know or guarantee
- separate entities, value objects, services, and workflows when their lifecycles differ
- check cohesion inside each object before adding new types or abstraction layers
- review the collaboration path for the main use case and note where state or decisions are misplaced
- recommend the smallest modeling change that clarifies responsibilities

## Outputs to Prefer

- explain object choices in terms of responsibilities and invariants
- show how collaborators interact on the main path
- highlight boundary objects versus domain objects when both are present
- prefer concrete modeling guidance over framework-specific jargon

## Common Requests

```text
Model this domain problem with objects, responsibilities, and collaborators.
```

```text
Review this object-oriented design for misplaced behavior, low cohesion, or unclear ownership.
```

## Safety Notes

- do not invent deep inheritance trees when composition is clearer
- avoid anemic domain models when the main behavior belongs with the domain state
- avoid forcing everything into objects when a simple procedure or module is the better fit
