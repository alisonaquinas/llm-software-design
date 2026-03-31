---
name: planguage-reader
description: >
  read, interpret, review, and summarize planguage requirements. use when the
  user asks to explain a planguage spec, review it for completeness, translate
  it into plain language, or compare it with stories, use cases, or acceptance
  criteria.
---

# Planguage Reader

Use this skill to explain what a Planguage requirement means, what it commits
to, and what is still missing.

## Intent Router

| Need | Load |
| --- | --- |
| interpretation checklist, translation rules, and review questions | `references/reading-checklist.md` |

## Quick Start

1. identify the tag, scale, meter, and target ladder
2. restate the requirement in plain language without losing the numeric meaning
3. separate committed goals from stretch or wish levels
4. identify assumptions, missing context, and design leakage
5. show how the requirement maps to testing, operations, or delivery decisions

## Workflow

- read the requirement as an object, not as a sentence fragment
- identify which fields are present and which are absent
- explain the scale in domain terms and the meter in evidence terms
- compare fail, goal, stretch, and wish to show the real commitment boundary
- call out missing units, unclear conditions, or untestable meter wording
- translate Planguage terms into plain-language acceptance meaning for mixed audiences
- compare the requirement with stories, use cases, or acceptance criteria when helpful
- summarize the most important ambiguity before discussing secondary cleanup items

## Outputs to Prefer

- a plain-language explanation of the requirement and its acceptance boundary
- a field-by-field review showing completeness and clarity gaps
- a translation table from Planguage fields to story, use-case, or test language
- a short risk note describing how the current wording could be misread

## Common Requests

```text
Read this Planguage requirement and explain what it really commits the team to.
```

```text
Review this spec for missing scale, meter, stakeholders, or target-level problems.
```

## Verification and Next Steps

- verify that the plain-language explanation still preserves the numeric commitment
- verify that missing fields are clearly labeled as missing rather than guessed
- identify whether the next best move is authoring cleanup, implementation planning, or test design
- call out one example of a likely misread if the requirement ships unchanged

## Safety Notes

- do not collapse stretch or wish levels into the actual goal
- do not rewrite the requirement silently while explaining it
- do not assume scale or meter intent when the text is genuinely ambiguous
- do not confuse business rationale with acceptance evidence
