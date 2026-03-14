---
name: design-patterns
description: >
  choose and critique common design patterns and their tradeoffs. use when the user asks whether a pattern fits a problem, how to apply strategy, observer, adapter, factory, decorator, or similar patterns, or how to avoid pattern overuse.
---

# Design Patterns

Use this skill to choose, critique, or adapt common design patterns for a concrete design problem.

## Intent Router

| Need | Load |
| --- | --- |
| selection heuristics, tradeoffs, and review checklist | `references/pattern-guide.md` |

## Quick Start

1. Start with the change pressure or collaboration problem before naming a pattern.
2. Prefer the simplest structure that solves the real variability, lifecycle, or dependency issue.
3. Use pattern names as shorthand for tradeoffs, not as goals by themselves.
4. Recommend only the parts of a pattern that materially help the problem at hand.

## Workflow

- describe the current pain in terms of variation, coordination, instantiation, or boundary mismatch
- compare one or two plausible patterns and explain why one fits better
- note the operational or maintenance cost introduced by the chosen pattern
- adapt the pattern to the codebase instead of recreating textbook structure mechanically
- identify the tests or seams that should become easier after the change

## Outputs to Prefer

- tie the pattern choice to a concrete problem and expected benefit
- explain the extra moving parts the pattern introduces
- recommend smaller alternatives when a full pattern would be overkill
- keep the explanation grounded in the user's actual code or scenario

## Common Requests

```text
Which design pattern best fits this variability or collaboration problem, and why?
```

```text
Review this use of a design pattern and call out over-engineering or a better alternative.
```

## Safety Notes

- do not prescribe a pattern when a simpler function, module, or conditional is clearer
- avoid pattern stacking when one focused abstraction would solve the problem
- do not confuse naming a pattern with proving the design is good
