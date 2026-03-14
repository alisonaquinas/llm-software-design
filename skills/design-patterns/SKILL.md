---
name: design-patterns
description: >
  choose, adapt, and critique software design patterns and their tradeoffs. use when the user asks whether a pattern fits a problem, how to apply strategy, state, observer, adapter, factory, builder, decorator, command, facade, proxy, or similar patterns, how to map a pattern into a specific language, how to show a practical implementation of a pattern, or how to avoid over-engineering and pattern cargo-culting.
---

# Design Patterns

Use this skill to choose, critique, or adapt design patterns for a concrete design problem and target language.

## Intent Router

| Need | Load |
| --- | --- |
| selection heuristics, pattern families, tradeoffs, and review checklist | `references/pattern-guide.md` |
| practical implementation templates for strategy, state, facade, decorator, adapter, builder, and observer | `references/pattern-implementations.md` |
| language-specific examples for Python, TypeScript, JavaScript, C, C++, C#, and Rust | `references/language-examples.md` |

## Quick Start

1. Start with the change pressure or collaboration problem before naming a pattern.
2. Compare the smallest plausible alternatives first: a function, a module, a table, an enum, or one focused abstraction may be enough.
3. Choose patterns based on what must vary: construction, behavior, lifecycle, coordination, or boundary shape.
4. Load `references/pattern-implementations.md` when the user needs code that shows how to wire the roles together in practice.
5. Explain both the benefit and the extra moving parts the pattern introduces.
6. Map the pattern into the language's native idioms instead of recreating textbook UML mechanically.

## Workflow

1. Describe the current pain in terms of variation, coordination, instantiation, lifecycle, or boundary mismatch.
2. Decide whether the variation is open or closed and whether it must be selected at compile time or runtime.
3. Compare one or two plausible patterns and name the simpler rejected alternative.
4. Show the concrete collaboration seam that becomes cleaner after the change.
5. Call out the operational and maintenance cost introduced by the pattern.
6. Identify the tests or extension scenarios that should become easier.
7. When the user asks for implementation help, show the minimal roles first, then a concrete example in the target language.
8. When relevant, translate the pattern into the user's language idioms and point out non-pattern alternatives.

## Typical Focus Areas

- choosing between strategy, state, command, and plain branching
- boundary repair with adapter, facade, proxy, or anti-corruption layers
- construction and configuration with factory, abstract factory, or builder
- behavior layering with decorator or composition
- notification and coordination with observer, mediator, or pub-sub
- replacing pattern overuse with simpler designs where appropriate

## Outputs to Prefer

- tie the pattern choice to a concrete problem and expected benefit
- show the minimal roles needed rather than every textbook participant
- explain the added indirection, allocation, configuration, or testing cost
- recommend a smaller alternative when a full pattern would be overkill
- when asked for examples, provide runnable or nearly-runnable code rather than only UML labels
- ground the advice in the user's language, runtime, and codebase constraints

## Common Requests

```text
Which design pattern best fits this variability or collaboration problem, and why?
```

```text
Review this use of a design pattern and call out over-engineering, misuse, or a better alternative.
```

```text
Show how this pattern should look in Python, TypeScript, JavaScript, C, C++, C#, or Rust.
```

```text
Give me a practical implementation of strategy, state, facade, decorator, adapter, builder, or observer.
```

## Safety Notes

- do not prescribe a pattern when a simpler function, module, enum, or conditional is clearer
- avoid pattern stacking when one focused abstraction would solve the problem
- do not confuse naming a pattern with proving the design is good
- be especially cautious with singleton, service locator, and framework-driven abstractions that hide dependencies
