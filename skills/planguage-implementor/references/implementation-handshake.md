# Planguage implementation handshake

## What implementation needs from the requirement

- a stable tag
- a measurable scale
- a reproducible meter
- at least one committed target level
- enough context to know where the measurement applies

## Handoff pattern

1. capture the requirement tag in planning artifacts
2. identify the code and runtime seams that influence the scale
3. define acceptance checkpoints from fail and goal
4. define instrumentation before or alongside implementation
5. keep stretch and wish as tradeoff inputs, not default scope

## Traceability pattern

| Requirement field | Delivery artifact |
| --- | --- |
| Tag | backlog item, ADR, epic, or traceability row |
| Scale | implementation metric or measured output |
| Meter | test harness, monitoring query, or analysis procedure |
| Goal | acceptance gate |
| Fail | rejection condition or rollback trigger |

## Common failure modes

- implementation has no way to produce measurement evidence
- design discussions replace the original measurable outcome
- stretch levels quietly become mandatory
- one requirement tag fans into many unrelated workstreams without decomposition
