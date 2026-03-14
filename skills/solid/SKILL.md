---
name: solid
description: >
  apply solid principles to class design, module boundaries, dependency direction, and refactoring discussions. use when the user asks about srp, ocp, lsp, isp, dip, maintainability, extensibility, or how to improve an object-oriented design without adding accidental complexity.
---

# SOLID

Use this skill to evaluate or improve a design using the SOLID principles.

## Intent Router

| Need | Load |
| --- | --- |
| principle-by-principle guidance, tradeoffs, and review checklist | `references/principles.md` |

## Quick Start

1. Identify the current responsibilities, dependencies, and extension points.
2. Check which SOLID principle is most relevant to the current pain instead of scoring every principle equally.
3. Call out concrete change-risk or maintainability problems, not abstract purity issues.
4. Prefer the smallest refactor that improves clarity, substitution safety, or dependency direction.

## Workflow

- state the design goal and the main reason the code is hard to change today
- list the main abstractions, their responsibilities, and their outgoing dependencies
- identify the one or two SOLID principles that most directly explain the pain
- recommend a focused refactor and the tradeoff it introduces
- note the verification needed after the change, such as tests or integration checks

## Outputs to Prefer

- map each finding to a specific responsibility, dependency, or extension seam
- explain why the issue matters for changeability or correctness
- recommend concrete refactor steps rather than slogan-level advice
- preserve useful cohesion and avoid introducing ceremony without a real change driver

## Common Requests

```text
Evaluate this class design against SOLID and point out the highest-leverage improvement.
```

```text
Refactor this design to improve dependency direction without adding unnecessary abstractions.
```

## Safety Notes

- do not force interface extraction or indirection without a clear change driver
- prefer cohesive modules over class proliferation
- do not treat SOLID as a reason to fragment a stable, understandable design
