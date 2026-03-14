---
name: transact-sql-best-practice
description: >
  review transact-sql code and planning work against common transact-sql conventions for formatting, naming, structure, testing, and tooling. use when the user asks for idiomatic transact-sql, t-sql code review, sql server procedure refactoring, or set-based t-sql performance and safety guidance.
---

# Transact-SQL Best Practice

Use this skill to review or improve Transact-SQL work using common ecosystem conventions instead of ad hoc local habits.

## Intent Router

| Need | Load |
| --- | --- |
| core conventions, tooling defaults, and review checklist for Transact-SQL | `references/best-practices.md` |

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
Review this Transact-SQL module for idiomatic structure, naming, boundary handling, and test gaps.
```

```text
Refactor this Transact-SQL snippet to follow common Transact-SQL best practice without changing behavior.
```

## Safety Notes

- do not force ecosystem migration unless the current stack is clearly blocking maintainability
- avoid style-only churn in legacy code that is otherwise stable
- preserve externally visible behavior unless the user asks for breaking changes
