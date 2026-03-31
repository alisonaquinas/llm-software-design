---
name: planguage-author
description: >
  author measurable planguage functional requirements and quality requirements.
  use when the user asks to draft, rewrite, normalize, or improve requirements
  in planguage form with clear tags, scales, meters, goal levels, and
  stakeholder context.
---

# Planguage Author

Use this skill to turn vague or mixed requirements into measurable
Planguage-style specifications.

## Intent Router

| Need | Load |
| --- | --- |
| template fields, authoring sequence, and anti-patterns | `references/authoring-patterns.md` |

## Quick Start

1. identify the stakeholder outcome and the future state to specify
2. assign one stable tag to one requirement object
3. define the scale with clear units, scope, and conditions
4. define the meter so the requirement can be tested the same way every time
5. set fail, goal, stretch, and wish levels when they add decision value
6. keep design ideas separate from the requirement itself

## Workflow

- start from the source material: interview notes, story text, standards, or defect reports
- separate goal statements, context, assumptions, and candidate design ideas
- choose a requirement tag that is stable, reusable, and narrow enough for one objective
- write the gist or ambition in plain business language before adding numeric targets
- define the scale so a reviewer can tell exactly what is being measured
- define the meter with a reproducible test, observation, or analysis method
- add baseline or benchmark values when they clarify current reality
- write fail, goal, stretch, and wish levels only when each level changes a decision
- record stakeholders, owner, source, and open questions that still affect target quality
- surface ambiguity instead of hiding it behind fake precision

## Outputs to Prefer

- a clean Planguage requirement block with tag, scale, meter, and target levels
- a short note explaining which source statements were normalized or split
- a list of missing facts when the requirement still lacks enough evidence
- paired suggestions for requirement decomposition when one statement hides multiple goals

## Common Requests

```text
Rewrite these functional requirements in Planguage with tags, scales, meters, and goal levels.
```

```text
Draft a Planguage requirement for response time, availability, and onboarding success.
```

## Verification and Next Steps

- verify that each requirement object expresses one main outcome
- verify that scale and meter allow two different reviewers to test the same thing
- verify that design choices were not smuggled into the requirement body
- name the smallest missing fact that would most improve the requirement quality

## Safety Notes

- do not invent numeric targets when the source only supports a question or range
- do not merge unrelated concerns into one tagged requirement
- do not treat stakeholder wishes as committed goals without evidence
- do not hide design constraints inside ambition, scale, or goal text
