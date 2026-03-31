---
name: planguage-implementor
description: >
  implement from planguage requirements without losing their measurable intent.
  use when the user asks how to turn planguage specs into architecture choices,
  delivery plans, instrumentation, acceptance checkpoints, or implementation
  slices while keeping requirement and design concerns separate.
---

# Planguage Implementor

Use this skill to turn Planguage requirements into implementation and delivery
work without losing the measurement model.

## Intent Router

| Need | Load |
| --- | --- |
| implementation handoff, traceability, and instrumentation patterns | `references/implementation-handshake.md` |

## Quick Start

1. extract the goal, fail, and meter before discussing solution options
2. identify the observability or instrumentation needed to prove compliance
3. derive candidate design moves that could satisfy the requirement
4. keep committed goals separate from stretch and wish targets
5. plan delivery slices that preserve evidence at each step

## Workflow

- read the Planguage requirement as a measurable contract
- identify the smallest technical seams that affect the scale and meter
- derive acceptance checkpoints from fail and goal levels
- identify instrumentation, logs, probes, or analytics needed to gather evidence
- compare design options based on expected effect on the measured scale
- translate the requirement into work slices, ADR candidates, and implementation checkpoints
- keep traceability from tag to code, tests, and operational dashboards
- flag requirement ambiguity before presenting detailed implementation advice

## Outputs to Prefer

- a delivery plan tied to the requirement tag and target levels
- a traceability matrix linking requirement, design choices, code areas, and evidence
- instrumentation and observability requirements needed to prove the goal
- a risk list showing which unknowns threaten compliance most

## Common Requests

```text
Turn this Planguage requirement into an implementation plan with evidence checkpoints.
```

```text
Explain which architecture options are most likely to satisfy this scale and goal.
```

## Verification and Next Steps

- verify that implementation tasks still trace back to the original scale and meter
- verify that the chosen design can actually produce the needed evidence
- identify the first thin slice that would reduce uncertainty fastest
- state whether the requirement is implementable now or still needs authoring cleanup

## Safety Notes

- do not silently rewrite the requirement to make the design easier
- do not treat stretch targets as committed scope
- do not propose architecture that cannot produce the required measurement evidence
- do not skip instrumentation and then assume compliance can be proven later
