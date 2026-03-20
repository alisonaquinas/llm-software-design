---
name: high-coherence
description: >
  maintain conceptual, module, architectural, and runtime coherence in software systems.
  use when the user asks how to keep a design internally consistent, preserve conceptual
  integrity, align boundaries with domain language, prevent architectural drift, review
  a system for coherence problems, or improve governance so implementation stays aligned
  with intended structure as the codebase and team evolve.
---

# High Coherence

Use this skill to keep a system's design story consistent across concepts, boundaries, dependencies, and runtime behavior.

## Intent Router

| Need | Load |
| --- | --- |
| coherence levels, review checklist, drift signals, and governance moves | `references/coherence-guide.md` |

## Quick Start

1. Start with the system's main concepts, invariants, and reasons to change.
2. Check whether module boundaries, dependency rules, and runtime interactions tell the same design story.
3. Look for duplicated concepts, boundary leaks, and coordination points that force synchronized change.
4. Prefer a small set of explicit rules that can be reviewed and tested continuously.
5. Recommend the smallest structural move that restores conceptual integrity and change locality.

## Workflow

- name the core business concepts and the boundaries expected to own them
- inspect whether responsibilities, names, and invariants stay consistent across modules and services
- check architectural conformance: allowed dependencies, layer direction, cycles, and shared-state seams
- compare intended architecture with runtime reality such as synchronous chains, shared databases, or must-deploy-together paths
- identify the main source of incoherence: concept drift, god modules, boundary leaks, or operational coupling
- recommend targeted fixes such as concept pruning, boundary realignment, architecture tests, ADRs, or ownership clarification
- describe how to verify that the design became easier to reason about and change

## Outputs to Prefer

- explain coherence in terms of concepts, boundaries, dependency rules, and runtime behavior
- tie findings to concrete maintenance costs such as drift, duplicated concepts, or synchronized deployment
- recommend lightweight governance: ADRs, architecture tests, dependency rules, and periodic review checkpoints
- distinguish root-cause incoherence from downstream symptoms
- prefer incremental boundary corrections over broad redesigns

## Common Requests

```text
Review this architecture for conceptual integrity, boundary clarity, drift risks, and the most effective coherence improvements.
```

```text
Explain why this system feels inconsistent and recommend small changes that align the domain model, module boundaries, and runtime interactions.
```

## Verification and Next Steps

- verify that names, invariants, and ownership boundaries now align across code, APIs, and operations
- verify that architecture rules are explicit and enforceable in review or CI
- show one follow-up metric or signal to monitor, such as cycle count, deployment coupling, or cross-boundary churn
- name the smallest next refactor that would further strengthen coherence without raising accidental complexity

## Safety Notes

- do not treat stylistic uniformity as a substitute for conceptual integrity
- avoid introducing extra layers or patterns unless they reduce real drift or boundary confusion
- do not recommend distributed boundaries when coordination cost would remain high
- keep metrics as signals, not as the sole definition of design quality
