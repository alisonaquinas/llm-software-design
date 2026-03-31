---
name: planguage-tester
description: >
  test and validate planguage requirements with evidence-driven acceptance
  design. use when the user asks to derive test cases, boundary checks, meter
  procedures, acceptance criteria, or audit evidence from planguage functional
  or quality requirements.
---

# Planguage Tester

Use this skill to derive acceptance evidence from Planguage requirements.

## Intent Router

| Need | Load |
| --- | --- |
| test design, boundary strategy, and evidence packaging | `references/testing-patterns.md` |

## Quick Start

1. start with the scale, meter, and goal rather than the solution
2. derive tests for fail, goal, and edge conditions separately
3. define the environment and workload needed to make the meter credible
4. specify how evidence will be recorded and reviewed
5. treat ambiguous requirement fields as blockers, not as silent assumptions

## Workflow

- identify the exact observable implied by the scale
- restate the meter as a repeatable test or analysis procedure
- design cases for fail thresholds, goal thresholds, and realistic operating conditions
- include data setup, timing method, workload profile, and pass or fail math
- identify what must be measured in development, staging, and production
- package results so an auditor can trace evidence back to the requirement tag
- call out where the requirement is not test-ready because fields are missing or weak

## Outputs to Prefer

- a test matrix mapped to tag, scale, meter, and target levels
- boundary and failure cases that make the acceptance line explicit
- an evidence package outline for audit, release, or compliance review
- a blocker list when the requirement cannot yet be tested reliably

## Common Requests

```text
Create acceptance tests for this Planguage requirement and show how to measure the result.
```

```text
Explain what evidence is needed to prove this goal level during release review.
```

## Verification and Next Steps

- verify that every test maps back to a named requirement field
- verify that the meter can be executed with the described tools and data
- verify that pass or fail math is explicit at the goal boundary
- identify the first missing requirement detail that blocks credible testing

## Safety Notes

- do not assume the meter if the requirement did not define one clearly
- do not confuse implementation telemetry with acceptance evidence unless the metric matches the scale
- do not test only the happy path when fail thresholds are explicit
- do not mark the requirement testable if key conditions or units remain undefined
