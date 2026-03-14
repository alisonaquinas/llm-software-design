---
name: bdd
description: >
  specify behavior through collaborative examples, executable scenarios, and
  shared language. use when the user asks about behavior-driven development,
  given-when-then scenarios, gherkin, cucumber, reqnroll, acceptance criteria,
  executable specifications, or how to connect business-facing examples to
  automated tests and delivery workflows.
---

# BDD

Use this skill to express behavior as examples that business, product, QA, and engineering roles can review together and automate safely.

## Intent Router

| Need | Load |
| --- | --- |
| collaboration flow, scenario quality rules, step design, and anti-patterns | `references/bdd-guide.md` |
| gherkin and tooling examples for python, javascript, typescript, c#, and related platforms | `references/platform-examples.md` |

## Quick Start

1. Start from an example conversation about behavior, not from test-framework syntax.
2. Name the capability in the domain's language before writing scenarios.
3. Use scenarios to describe rules, outcomes, and observable signals.
4. Keep step wording stable while implementation details evolve beneath it.
5. Automate only scenarios that communicate a valuable rule or contract.

## Workflow

1. Identify the capability, actor, preconditions, trigger, and observable outcome.
2. Turn that example into a small scenario using Given/When/Then language.
3. Extract domain vocabulary that should remain readable to non-programmers.
4. Decide whether the scenario belongs at acceptance, API, component, or UI level.
5. Implement step bindings with minimal duplication and keep technical details below the scenario layer.
6. Review the scenario for ambiguity, incidental UI detail, and missing business rules.
7. Add lower-level tests where algorithmic branches or edge cases exceed the communication value of Gherkin.

## Outputs to Prefer

- prefer concise scenarios that encode business rules and outcomes
- show where BDD ends and lower-level tests begin
- keep steps declarative and domain-oriented
- recommend scenario tables only when they improve readability for rules with many examples
- call out collaboration checkpoints before automation work begins

## Common Requests

```text
Convert these requirements or acceptance criteria into Given/When/Then scenarios and note the right automation level.
```

```text
Review this Gherkin or step-definition suite for brittle wording, technical leakage, or missing domain language.
```

```text
Show how to automate these scenarios with Cucumber, Reqnroll, behave, or a related BDD stack.
```

## Safety Notes

- do not turn every unit-level rule into Gherkin; keep executable specifications focused on behaviors worth shared review
- avoid UI choreography in scenarios when the real rule lives at API or domain level
- avoid duplicate scenario wording that differs only cosmetically
- do not hide ambiguous requirements under overly generic steps such as "the system works correctly"
