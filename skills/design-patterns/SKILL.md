---
name: design-patterns
description: >
  Choose, compare, and critique common software design patterns such as strategy, factory, observer, adapter, decorator, and command. Use when the user asks which pattern fits a problem, whether a pattern is overkill, or how to implement one without unnecessary complexity.
---

# Design Patterns

Use this skill to match recurring design problems to proven patterns without turning patterns into ceremony.

## Intent Router

| Need | Load |
| --- | --- |
| Pattern selection and tradeoffs | `references/pattern-guide.md` |

## Quick Reference

1. Define the change or variability problem first.
2. Pick a pattern only if it reduces coupling or clarifies behavior.
3. Explain the concrete participants in the current domain, not just the textbook roles.
4. State the cost of the pattern so the user can judge whether it is worth it.

## Pattern Selection

- Use Strategy for swappable algorithms.
- Use Factory when creation logic needs to vary or stay centralized.
- Use Adapter when integrating a mismatched interface.
- Use Decorator when layering optional behavior.
- Use Observer when one change should notify multiple dependents.

## Safety Notes

- Do not introduce a pattern solely because it is familiar.
- Prefer plain functions or modules when the problem is small.
