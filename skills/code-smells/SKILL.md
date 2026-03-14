---
name: code-smells
description: >
  identify maintainability risks, code smells, and refactoring opportunities. use when the user asks for a code review focused on duplication, long methods, hidden dependencies, feature envy, shotgun surgery, or pragmatic cleanup sequencing.
---

# Code Smells

Use this skill to identify maintainability risks and propose pragmatic refactoring paths.

## Intent Router

| Need | Load |
| --- | --- |
| smell categories, triage order, and review checklist | `references/smell-catalog.md` |

## Quick Start

1. Start by identifying the smells that most directly block safe change.
2. Tie each smell to a concrete maintenance cost such as hidden coupling, duplication, or fragile edits.
3. Prioritize refactors that simplify understanding and testing before broad stylistic cleanups.
4. Recommend a sequence of small improvements rather than a heroic rewrite.

## Workflow

- summarize the main maintenance pain in one sentence
- identify the strongest smells and the code locations that exhibit them
- explain why each smell matters for change risk, defect risk, or debugging cost
- recommend a staged refactor plan with the safest first move
- note the tests or characterization checks needed before deeper cleanup

## Outputs to Prefer

- rank findings by maintenance impact or refactor leverage
- connect smells to concrete symptoms in the code
- recommend small, behavior-preserving moves where possible
- distinguish between superficial style issues and structural maintainability problems

## Common Requests

```text
Review this code for maintainability smells and prioritize the cleanup sequence.
```

```text
Explain which smells matter most here and suggest pragmatic refactors that preserve behavior.
```

## Safety Notes

- do not label every disagreement in style as a code smell
- avoid rewrite-heavy recommendations when small refactors can remove the real risk
- preserve behavior unless the request explicitly allows design-level change
