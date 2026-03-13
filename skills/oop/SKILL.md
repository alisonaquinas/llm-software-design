---
name: oop
description: >
  Reason about object-oriented modeling, class responsibilities, object collaboration, composition, inheritance, and encapsulation. Use when the user asks how to model a domain, split responsibilities across classes, or improve an object-oriented design.
---

# OOP

Use this skill to shape object-oriented designs around responsibilities and collaboration.

## Intent Router

| Need | Load |
| --- | --- |
| Modeling heuristics and tradeoffs | `references/modeling.md` |

## Quick Reference

1. Start from domain behavior, not from nouns alone.
2. Assign responsibilities where the needed data and invariants already live.
3. Prefer composition over inheritance unless subtype substitution is genuinely required.
4. Keep object APIs small, intention-revealing, and state-safe.

## Modeling Pattern

- Identify core entities, value objects, and services.
- Define which invariants each object protects.
- Describe how collaborators interact at a message level.
- Minimize bidirectional coupling.

## Safety Notes

- Avoid anemic models when behavior clearly belongs with the data.
- Avoid inheritance trees used only for code reuse.
