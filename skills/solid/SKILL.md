---
name: solid
description: >
  apply solid principles to class design, module boundaries, dependency direction,
  and refactoring discussions. use when the user asks about srp, ocp, lsp, isp,
  dip, maintainability, extensibility, object-oriented design, trait design,
  interface design, or how to improve changeability without adding accidental
  complexity.
---

# SOLID

Use this skill to evaluate or improve a design using the SOLID principles.

## Intent Router

| Need | Load |
| --- | --- |
| principle-by-principle guidance, tradeoffs, and review checklist | `references/principles.md` |
| language-specific examples for python, typescript, javascript, c, c++, c#, and rust | `references/language-examples.md` |

## Quick Start

1. Identify the concrete change pressure first: new variant, new integration, easier testing, safer substitution, or smaller interfaces.
2. Check which one or two SOLID principles best explain the pain instead of scoring every principle equally.
3. Tie findings to responsibilities, extension seams, contracts, or dependency direction that appear in the code.
4. Prefer the smallest refactor that improves changeability while preserving useful cohesion and runtime simplicity.

## Workflow

- state the design goal and the main reason the code is hard to change today
- list the main abstractions, their responsibilities, and their outgoing dependencies
- identify the one or two SOLID principles that most directly explain the pain
- choose the language-appropriate mechanism: protocol, trait, interface, module seam, callback table, or simple function
- recommend a focused refactor and the tradeoff it introduces
- note the verification needed after the change, such as tests, contract checks, or integration checks

## Outputs to Prefer

- map each finding to a specific responsibility, dependency, substitution rule, or interface problem
- explain why the issue matters for changeability, correctness, or test isolation
- recommend concrete refactor steps rather than slogan-level advice
- preserve useful cohesion and avoid introducing ceremony without a real change driver
- adapt SOLID to the language instead of forcing nominal-interface patterns everywhere

## Common Requests

```text
Evaluate this class or module design against SOLID and point out the highest-leverage improvement.
```

```text
Refactor this design to improve dependency direction or substitutability without adding unnecessary abstractions.
```

## Safety Notes

- do not force interface extraction, trait splitting, or indirection without a clear change driver
- prefer cohesive modules over class proliferation
- do not treat SOLID as a reason to fragment a stable, understandable design
- do not assume inheritance is the primary tool; composition, protocols, traits, and modules are often a better fit
