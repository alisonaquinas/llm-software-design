---
name: solid
description: >
  Apply SOLID principles to class design, module boundaries, dependency direction, and refactoring discussions. Use when the user asks about SRP, OCP, LSP, ISP, DIP, maintainability, extensibility, or how to improve an object-oriented design without adding accidental complexity.
---

# SOLID

Use this skill to evaluate or improve a design using the SOLID principles.

## Intent Router

| Need | Load |
| --- | --- |
| Principle-by-principle review or examples | `references/principles.md` |

## Quick Reference

1. Identify the current responsibilities, dependencies, and extension points.
2. Check for each SOLID principle whether the design is helping or hurting changeability.
3. Call out concrete risks, not abstract purity issues.
4. Prefer the smallest refactor that improves clarity or dependency direction.

## Review Pattern

- State the design goal in one sentence.
- List the main abstractions and what each is responsible for.
- Highlight which principle is most relevant to the current pain.
- Recommend a focused change and the tradeoff it introduces.

## Safety Notes

- Do not force interface extraction or indirection without a clear change driver.
- Prefer cohesive modules over class proliferation.
