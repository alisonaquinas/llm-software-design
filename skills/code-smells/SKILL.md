---
name: code-smells
description: >
  identify maintainability risks, code smells, and refactoring opportunities.
  use when the user asks for a code review focused on duplication, long methods,
  hidden dependencies, feature envy, shotgun surgery, primitive obsession,
  broad interfaces, or pragmatic cleanup sequencing in python, typescript,
  javascript, c, c++, c#, rust, or other codebases.
---

# Code Smells

Use this skill to identify maintainability risks and propose pragmatic refactoring paths.

## Intent Router

| Need | Load |
| --- | --- |
| smell categories, root-cause triage, and review checklist | `references/smell-catalog.md` |
| language-specific smell examples for python, typescript, javascript, c, c++, c#, and rust | `references/language-examples.md` |

## Quick Start

1. Start by identifying the smells that most directly block safe change.
2. Tie each smell to a concrete maintenance cost such as hidden coupling, duplication, or fragile edits.
3. Prioritize refactors that simplify understanding, ownership, and testing before broad stylistic cleanup.
4. Recommend a sequence of small improvements rather than a heroic rewrite.

## Workflow

- summarize the main maintenance pain in one sentence
- identify the strongest smells and the code locations that exhibit them
- distinguish root-cause smells from downstream symptoms
- explain why each smell matters for change risk, defect risk, debugging cost, or review friction
- recommend a staged refactor plan with the safest first move
- note the tests or characterization checks needed before deeper cleanup

## Outputs to Prefer

- rank findings by maintenance impact or refactor leverage
- connect smells to specific code symptoms, not just labels
- recommend small, behavior-preserving moves where possible
- distinguish superficial style issues from structural maintainability problems
- call out which smells are acceptable tradeoffs versus urgent structural risks

## Common Requests

```text
Review this code for maintainability smells and prioritize the cleanup sequence.
```

```text
Explain which smells matter most here and suggest pragmatic refactors that preserve behavior.
```

## Verification and Next Steps

- verify the cleanup order with characterization tests around the smelliest path first
- show which smell is the root cause and which symptoms should disappear after the first refactor
- keep refactors behavior-preserving until the maintenance risk is back under control

## Safety Notes

- do not label every disagreement in style as a code smell
- avoid rewrite-heavy recommendations when small refactors can remove the real risk
- preserve behavior unless the request explicitly allows design-level change
- do not recommend abstraction merely to “fix” a smell if the result would be less direct than the original code
