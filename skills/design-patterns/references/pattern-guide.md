# Pattern guide

## Core lens

Patterns are reusable tradeoff packages. Select them based on the kind of change or coordination problem present, then adapt them to the local codebase rather than copying every textbook role.

## Common pattern families

- **Creation patterns**: factory method, abstract factory, builder. Use when construction logic or dependency assembly is the real problem.
- **Structural patterns**: adapter, facade, decorator, proxy, composite. Use when boundaries, compatibility, or layering are the pain.
- **Behavioral patterns**: strategy, observer, command, state, template method, mediator. Use when variation in behavior or collaboration flow keeps changing.

## Selection heuristics

- choose **strategy** when behavior varies behind a stable interface
- choose **adapter** when existing interfaces do not line up but behavior is otherwise acceptable
- choose **decorator** when behavior should be layered without subclass explosion
- choose **observer** when one change must notify several dependents without tight coupling
- choose **state** when behavior changes materially across explicit lifecycle modes

## Review checklist

- [ ] the underlying problem is described before the pattern name appears
- [ ] the chosen pattern solves a real variability, construction, or boundary issue
- [ ] the design avoids unnecessary roles or indirection from textbook over-application
- [ ] the resulting code should be easier to test or extend for the stated reason
- [ ] a simpler alternative was considered and rejected for a concrete reason

## Warning signs

- the pattern adds more types than the problem needs
- the pattern is present but the variation point never changes
- the codebase now depends on ceremony rather than clarity
- a framework feature already provides the same mechanism more directly
