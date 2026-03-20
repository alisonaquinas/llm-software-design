---
name: low-coupling
description: >
  reduce structural, contract, temporal, and operational coupling in software systems.
  use when the user asks how to localize change, break dependency cycles, separate
  volatile details from stable policy, review a design for hidden dependencies, define
  better seams between modules or services, or choose refactors that lower blast radius,
  test friction, and coordinated deployment cost.
---

# Low Coupling

Use this skill to minimize dependency strength and blast radius while keeping boundaries practical and testable.

## Intent Router

| Need | Load |
| --- | --- |
| coupling types, measurement signals, refactoring moves, and review checklist | `references/coupling-guide.md` |

## Quick Start

1. Start by locating the change that currently ripples too far.
2. Identify which form of coupling is dominant: structural, schema, temporal, shared-state, or operational.
3. Look for seams where policy can depend on abstractions and volatile details can move behind adapters or interfaces.
4. Constrain the design with explicit dependency rules before attempting large refactors.
5. Re-measure after each change so cycle count, propagation, or coordination cost trends move in the right direction.

## Workflow

- identify the main source of coupling and the concrete ripple effect it causes
- inspect dependency direction, cycles, shared state, contract ownership, and synchronized deployment paths
- separate stable policy from volatile implementation details
- recommend seams such as interfaces, ports, adapters, queues, anti-corruption layers, or module boundaries only where a real change driver exists
- prioritize work on highly central components, recurring co-change clusters, and boundaries with high coordination cost
- add executable rules such as no-cycle checks, layer constraints, or contract verification
- propose the smallest sequence of behavior-preserving refactors that lowers blast radius

## Outputs to Prefer

- explain coupling in terms of change locality, blast radius, and coordination cost
- distinguish structural coupling from schema, temporal, and operational coupling
- recommend dependency inversion and information hiding only where they simplify future change
- pair design advice with concrete measurement signals such as cycles, Ca/Ce, instability, or co-change hotspots
- prefer incremental seam creation over speculative abstraction

## Common Requests

```text
Review this design for hidden dependencies, coupling hotspots, and the safest sequence of refactors to localize change.
```

```text
Explain how to break these cycles or service dependencies without creating a more complicated architecture than the problem requires.
```

## Verification and Next Steps

- verify that one targeted change now touches fewer modules, packages, or services
- verify that dependency direction is explicit and enforceable
- show which metric or hotspot should improve first, such as cycles, centrality, or deployment coordination
- name one follow-up seam that would further reduce coupling only if the same pressure persists

## Safety Notes

- do not recommend abstraction, messaging, or service splits without a clear change or ownership driver
- avoid replacing one form of tight coupling with hidden operational complexity
- do not ignore contract evolution, idempotency, or observability when suggesting asynchronous decoupling
- keep refactors behavior-preserving until the system is stable enough for deeper redesign
