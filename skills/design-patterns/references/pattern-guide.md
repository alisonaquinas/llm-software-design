# Pattern guide

## Core lens

Patterns are reusable tradeoff packages. Select them based on the specific kind of change or coordination problem present, then adapt them to the local language and codebase instead of copying every textbook role.

## Start with the pressure

Identify which pressure is actually present:

- **construction pressure**: object setup is complex, variant-specific, or order-sensitive
- **behavior variation**: one stable call site must support several algorithms or rules
- **lifecycle variation**: behavior changes as state transitions occur
- **boundary mismatch**: interfaces or data shapes do not line up cleanly
- **notification or coordination**: one change must fan out to multiple dependents
- **cross-cutting behavior**: logging, retries, caching, timing, or authorization must wrap existing behavior

If none of these are strong, a named pattern may be unnecessary.

## Pattern families

### Creational

- **Factory Method**: move selection of concrete creation into a dedicated method or creator role
- **Abstract Factory**: create families of related objects that must stay compatible
- **Builder**: manage stepwise assembly of complex objects, especially when optional configuration is large or order matters

### Structural

- **Adapter**: reshape one interface to match another without rewriting the adapted implementation
- **Facade**: provide a simpler, narrower entry point over a complicated subsystem
- **Decorator**: layer additional behavior around a stable contract without subclass explosion
- **Proxy**: insert indirection for remoting, caching, authorization, lazy loading, or access control
- **Composite**: treat single items and nested groups uniformly when recursive structure is central

### Behavioral

- **Strategy**: swap algorithms or policies behind a stable contract
- **State**: move state-dependent behavior out of long conditionals into explicit states or transitions
- **Observer**: notify dependents when something changes without tight direct coupling
- **Command**: encapsulate an action so it can be queued, logged, retried, undone, or routed
- **Mediator**: centralize multi-party coordination when peers are too interdependent
- **Template Method**: fix the outer algorithm while allowing selected customization points

## Fast selection heuristics

### Choose strategy when

- behavior varies behind a stable interface
- the caller should not know the algorithm details
- new algorithms may be added later

Prefer a plain function or callable when each strategy has little or no state.

### Choose state when

- behavior changes materially across explicit lifecycle modes
- transitions are part of the domain and deserve names
- long branching over status values is spreading across methods

Prefer an enum or tagged union when the state set is closed and local.

### Choose adapter when

- the existing implementation is acceptable but its interface does not match what callers need
- replacing the underlying library or SDK is not desirable right now
- the mismatch is mostly about names, shapes, or call conventions

### Choose facade when

- a subsystem is too broad or noisy for most consumers
- you want a stable entry point over a volatile or third-party subsystem
- onboarding and test setup are harder than they should be

### Choose decorator when

- behavior should be layered without subclass explosion
- several optional wrappers may be combined
- the base contract should remain stable

Prefer higher-order functions or middleware pipelines when the language makes them cheaper and clearer.

### Choose observer when

- one change must notify several dependents
- the publisher should not know detailed subscriber behavior
- fan-out is real and recurring

Prefer direct calls when there is only one stable dependent.

### Choose factory or builder when

- construction logic has branching, defaults, validation, or dependency assembly that callers should not repeat
- families of related objects must stay compatible
- configuration size is large enough that constructors become hard to read

Prefer normal constructors when object creation is straightforward.

## Open-versus-closed set rule

Before recommending a pattern, ask whether new variants are expected:

- **closed set**: prefer enums, tagged unions, exhaustive branching, or table-driven logic
- **open set**: prefer interfaces, traits, protocols, abstract bases, factories, or plugin registration

This rule prevents many unnecessary pattern-heavy hierarchies.

## Pattern costs to call out explicitly

Every recommendation should mention at least one cost:

- more types and indirection
- harder navigation in small codebases
- more configuration or wiring
- runtime dispatch or allocation cost
- more difficult debugging when behavior is wrapped or routed indirectly
- increased test surface due to more seams

A pattern is worth it only when those costs buy clearer changeability.

## Common substitutions and near-misses

| Actual need | Often-better first move | Pattern to consider only if needed |
| --- | --- | --- |
| pick one algorithm | function parameter or callable | strategy |
| handle a closed state machine | enum or tagged union | state |
| simplify a noisy subsystem | helper module or focused API | facade |
| add logging or retries | middleware or wrapper function | decorator |
| bridge one third-party SDK | translation function or thin wrapper | adapter |
| create a configured object | constructor with named options | builder |
| notify one known dependent | direct call | observer |

## Pattern review checklist

- [ ] the underlying problem is described before the pattern name appears
- [ ] the variation is open or closed, and compile-time or runtime, with a concrete reason
- [ ] the chosen pattern solves a real variability, construction, or boundary issue
- [ ] the design uses only the roles that materially help the problem
- [ ] a simpler alternative was considered and rejected for a concrete reason
- [ ] the resulting code should be easier to test, extend, or reason about for the stated reason
- [ ] the advice fits the target language instead of forcing textbook structure

## Warning signs and anti-patterns

- the pattern adds more types than the problem needs
- the supposed variation point never actually changes
- a framework feature already provides the same mechanism more directly
- singleton is used to hide dependency management instead of solving a true uniqueness requirement
- service locator hides the dependency graph and makes tests harder to reason about
- abstract factory, builder, and strategy are all stacked where one simpler abstraction would do
- command objects are created even though actions are never queued, retried, logged, or undone

## How to answer with this guide

When using this skill, prefer answers in this shape:

1. **Problem pressure**: what keeps changing or coordinating poorly
2. **Best-fit pattern**: and why it fits better than one or two alternatives
3. **Minimal structure**: only the roles needed here
4. **Tradeoffs**: extra moving parts and maintenance cost
5. **Language mapping**: how the pattern should look in the target language
