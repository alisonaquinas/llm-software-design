---
name: oop
description: >
  reason about object-oriented modeling, responsibilities, collaborations, and object boundaries. use when the user asks how to model a domain with objects, structs, traits, interfaces, or modules; how to choose between composition, inheritance, polymorphism, or plain functions; how to place behavior near state and invariants; or how to review an existing object-oriented design for cohesion, ownership, lifecycle, or boundary problems.
---

# OOP

Use this skill to reason about object modeling, responsibility placement, collaboration design, and language-specific object-oriented tradeoffs.

## Intent Router

| Need | Load |
| --- | --- |
| core modeling heuristics, responsibility assignment, and review checklist | `references/modeling.md` |
| language-specific examples for Python, TypeScript, JavaScript, C, C++, C#, and Rust | `references/language-examples.md` |

## Quick Start

1. Identify the domain concepts, invariants, and lifecycle boundaries before proposing classes, traits, or interfaces.
2. Place behavior near the data and rules it must protect; do not strand core logic in controllers, handlers, or utility bags.
3. Prefer composition, explicit collaborators, and small interfaces over deep inheritance trees.
4. Choose the lightest abstraction that fits the change pressure: sometimes that is a value object, sometimes a service, and sometimes just a function or module.
5. Explain the design in terms of ownership, invariants, collaboration flow, and extension seams rather than only naming OOP principles.

## Workflow

1. Name the core concepts, what each must know, and what each must guarantee.
2. Separate entities, value objects, policies, services, aggregates, workflows, and boundary adapters when their lifecycles or change drivers differ.
3. Decide whether the variation is open or closed. Use polymorphism only when interchangeable behavior is a real recurring need.
4. Check cohesion inside each object before adding new types or abstraction layers.
5. Review the main use-case path and note where state, decisions, or side effects are currently misplaced.
6. Recommend the smallest modeling change that improves clarity, correctness, and testability.
7. When relevant, map the recommendation into the target language's idioms instead of forcing textbook class hierarchies.

## Typical Focus Areas

- entity versus value-object boundaries
- state ownership, lifecycle transitions, and invariants
- collaboration paths between domain objects, services, and boundaries
- composition versus inheritance versus procedural alternatives
- interface shape, substitution safety, and extension seams
- language-specific modeling choices such as traits, protocols, records, enums, or function tables

## Outputs to Prefer

- start with the domain pressure: invariants, lifecycle, variation, or coordination
- describe the object model in terms of responsibilities and collaborators
- call out why each abstraction exists and what change it is meant to absorb
- include one smaller alternative when a full object model would be overkill
- keep advice grounded in the user's codebase, language, and maintenance needs

## Common Requests

```text
Model this domain problem with objects, responsibilities, and collaborators.
```

```text
Review this object-oriented design for misplaced behavior, low cohesion, unclear ownership, or hierarchy abuse.
```

```text
Show how this design should look in Python, TypeScript, JavaScript, C, C++, C#, or Rust.
```

## Safety Notes

- do not invent deep inheritance trees when composition or data-oriented modeling is clearer
- avoid anemic domain models when the main behavior belongs with the domain state
- avoid forcing everything into objects when a simple procedure, module, enum, or table-driven design is the better fit
- do not recommend polymorphism unless the substitution boundary and expected variation are both clear
