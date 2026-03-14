---
name: objective-c-best-practice
description: >
  review objective-c code and planning work against common objective-c conventions for formatting, naming, structure, testing, and tooling. use when the user asks for idiomatic objective-c, objective-c code review, objective-c refactoring guidance, cocoa naming conventions, or objective-c api design.
---

# Objective-C Best Practice

Use this skill to review or improve Objective-C work using common ecosystem conventions instead of ad hoc local habits.

## Intent Router

| Need | Load |
| --- | --- |
| core conventions, tooling defaults, and review checklist for Objective-C | `references/best-practices.md` |

## Quick Start

1. Confirm the target version, dialect, runtime, framework, or vendor before recommending changes.
2. Prefer existing project conventions when they are already enforced and internally consistent.
3. Apply the default guidance in `references/best-practices.md` for naming, structure, testing, and tooling.
4. Recommend the smallest change set that improves clarity, safety, and maintainability.

## Workflow

- Identify the runtime, dialect, or host environment before making specific recommendations.
- Separate language-level guidance from framework-, vendor-, or platform-specific conventions.
- Prioritize correctness, readability, changeability, and operability before micro-optimizations.
- Note the automation path: formatter, linter, type checker, compiler flags, or test runner.
- Call out the highest-leverage refactors first instead of producing style-only churn.

## Typical Focus Areas

- naming, layout, and public API clarity
- boundary handling, state management, and error paths
- dependency direction, module structure, and test seams
- tooling, CI checks, and repeatable local verification
- performance, portability, or safety constraints only when they materially affect the design

## Outputs to Prefer

- summarize the governing constraints before detailed recommendations
- group findings by severity, maintenance impact, or migration effort
- recommend concrete edits, checks, or follow-up tests
- preserve externally visible behavior unless the request explicitly allows semantic changes

## Common Requests

```text
Review this Objective-C module for idiomatic structure, naming, boundary handling, and test gaps.
```

```text
Refactor this Objective-C snippet to follow common Objective-C best practice without changing behavior.
```

## Safety Notes

- do not force ecosystem migration unless the current stack is clearly blocking maintainability
- avoid style-only churn in legacy code that is otherwise stable
- preserve externally visible behavior unless the user asks for breaking changes
