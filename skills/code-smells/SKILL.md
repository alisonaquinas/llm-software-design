---
name: code-smells
description: >
  Identify maintainability problems such as long methods, large classes, feature envy, shotgun surgery, duplicated logic, primitive obsession, and inappropriate coupling. Use when the user asks for a design review, refactoring guidance, or an explanation of why code feels brittle or hard to change.
---

# Code Smells

Use this skill to identify maintainability risks and explain which refactoring direction is most appropriate.

## Intent Router

| Need | Load |
| --- | --- |
| Common smells and refactoring matches | `references/smell-catalog.md` |

## Quick Reference

1. Describe the symptom in observable terms.
2. Connect it to the change cost it creates.
3. Recommend the smallest refactor that improves cohesion or reduces coupling.
4. Prioritize smells that block frequent changes over stylistic complaints.

## Review Pattern

- Identify the hotspot.
- Name the smell only after describing the evidence.
- Explain the impact on readability, testing, or change safety.
- Suggest a sequence of small refactors.

## Safety Notes

- Do not propose broad rewrites when extraction or movement would solve the issue.
- Distinguish domain complexity from accidental complexity.
