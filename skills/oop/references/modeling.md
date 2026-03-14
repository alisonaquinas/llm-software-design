# Modeling guide

## Core lens

Model around responsibilities, invariants, and lifecycles. Good object design keeps the data that must stay consistent close to the behavior that enforces those rules, while keeping orchestration and external I/O at clearer boundaries.

## Start from the problem, not the class diagram

Before proposing types, answer these questions:

1. What must stay true after each operation?
2. Which concepts have identity over time, and which are just values?
3. Which decisions require access to state and rules together?
4. Where are the boundaries to storage, network, UI, clocks, random generators, or other external systems?
5. Which parts are likely to vary independently in the future?

If those answers are not clear, class design will usually drift into wrappers, god objects, or service sprawl.

## Useful distinctions

### Entity

Use an entity when identity matters across time and lifecycle transitions are meaningful.

Typical signs:

- it can be created, updated, archived, or deleted
- different instances may have the same field values but are still not the same thing
- audit history, ownership, or state transitions matter

### Value object

Use a value object when equality is by value and the type exists to bundle data plus rules.

Typical signs:

- it is immutable or mostly immutable
- it validates itself at construction
- behavior is local and rule-oriented, such as normalization, comparison, formatting, arithmetic, or range checks

### Aggregate or consistency boundary

Use an aggregate when a cluster of entities and value objects must preserve invariants as one unit. The aggregate root exposes operations and protects internal consistency.

Typical signs:

- several objects must change together
- external callers should not mutate nested objects arbitrarily
- the main issue is transactional consistency, not reuse

### Service or policy object

Use a service when behavior coordinates multiple collaborators or applies policy that does not naturally belong to one entity.

Typical signs:

- the logic uses several objects symmetrically
- the behavior mostly orchestrates or evaluates rules
- the type has little or no durable state of its own

### Boundary object or adapter

Use a boundary object to translate between the domain and external systems such as persistence, HTTP, messaging, files, or UI.

Typical signs:

- mapping, serialization, retries, transport concerns, or SDK details dominate the code
- the code would be unstable if external APIs changed
- you want to isolate infrastructure from domain logic

## Responsibility placement heuristics

Ask these questions in order:

1. Which object owns the invariant?
2. Which object already has the information needed to decide?
3. Which object should trigger the next collaborator on the happy path?
4. Which object would become misleading or dangerously incomplete if this logic stayed elsewhere?

Useful moves:

- move validation or rule enforcement closer to the state it protects
- introduce a value object when primitive fields repeatedly travel together with rules
- split orchestration from domain behavior when one type is doing both
- collapse needless wrappers when they add no real responsibility or boundary value

## Choosing between composition, inheritance, and alternatives

### Prefer composition when

- you want to mix and match behavior without subclass explosion
- the variation affects only part of the behavior
- substitutability would be hard to explain or verify
- runtime configuration matters

### Use inheritance only when

- the child truly is substitutable for the parent
- shared behavior and invariants are meaningful at the base level
- callers benefit from treating several concrete types through one stable contract

### Prefer plain functions, modules, or tables when

- the data is simple and long-lived object identity adds little value
- the main logic is transformation rather than collaboration
- introducing types would mostly add ceremony instead of preserving invariants

## Variation analysis

Before adding polymorphism, identify whether the set of variants is:

- **closed**: a known finite set that changes rarely; enums, tagged unions, or explicit branching may fit better
- **open**: new variants are expected from plugins, vendors, or feature growth; traits, interfaces, protocols, or vtables may fit better

Also decide whether the variability is:

- compile-time versus runtime
- local to one module versus spread across many call sites
- behavior-only versus behavior plus state and lifecycle

## Collaboration design

A good collaboration path has:

- one clear owner of each state change
- explicit boundaries around I/O and side effects
- dependency direction from policy toward abstractions or stable contracts
- enough locality that a maintainer can follow the main use case without jumping through dozens of files

When reviewing a collaboration path, trace one concrete scenario and note:

1. where the request enters
2. where the domain decision is made
3. where state mutates
4. where side effects happen
5. who confirms or reports the result

## Review checklist

- [ ] major concepts are represented at the right level of abstraction
- [ ] entities, value objects, services, and boundaries are not collapsed into one oversized type
- [ ] responsibilities are cohesive inside each object or module
- [ ] domain behavior is not stranded in controllers, handlers, or utility classes
- [ ] collaborations are explicit and understandable on the main use-case path
- [ ] inheritance is justified by substitutability rather than convenience
- [ ] the design names clear extension seams and stable invariants
- [ ] the recommendation fits the target language rather than assuming one universal OOP style

## Common smell-to-fix mappings

| Smell | Usually means | Often-helpful move |
| --- | --- | --- |
| data bag with procedural helpers | behavior is far from invariants | move rules into the owning type or create a value object |
| god object | orchestration, policy, and storage concerns are mixed | split domain state from services and boundaries |
| deep inheritance tree | variation is poorly isolated | flatten hierarchy and compose capabilities |
| repeated primitive groups | missing domain concept | introduce a value object |
| manager/service/repository doing everything | poor boundary definition | separate domain policy from infrastructure and workflow |
| interface for every class | abstractions were added without a change driver | keep concrete types until a stable seam is needed |

## How to answer with this guide

When using this skill, prefer answers in this shape:

1. **Problem pressure**: invariant, lifecycle, variation, or boundary mismatch
2. **Proposed model**: entities, value objects, services, and boundaries
3. **Why this placement**: which type owns which rule or state
4. **Tradeoffs**: complexity added, alternatives rejected, likely test impact
5. **Language mapping**: how the design should look in the target language
