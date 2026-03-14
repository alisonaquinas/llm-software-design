# Smell catalog

## Core lens

A code smell is a symptom that change is becoming risky, expensive, or confusing. Focus on smells that create hidden coupling, duplication, brittle edits, or debugging friction.

## Common smells

- **Long method or long function**: too many responsibilities or too much hidden state in one place.
- **Large class or module**: policy, orchestration, and infrastructure concerns are entangled.
- **Duplicated logic**: similar change must be applied in several places, increasing drift risk.
- **Feature envy**: behavior sits far from the data or invariants it depends on.
- **Shotgun surgery**: one change requires many scattered edits.
- **Hidden dependencies**: important collaborators are global, implicit, or hard to see from the surface API.

## Triage order

- start with smells that make safe change hardest today
- prefer refactors that improve understanding and test seams simultaneously
- separate root-cause smells from downstream symptoms
- delay purely aesthetic cleanup until structural issues are under control

## Review checklist

- [ ] each smell is tied to a concrete maintenance or defect risk
- [ ] the strongest smells are prioritized rather than listed flatly
- [ ] recommendations favor behavior-preserving steps where possible
- [ ] follow-up tests or characterization checks are identified
- [ ] the refactor sequence starts with the move that unlocks safer further cleanup

## Common refactor moves

- extract cohesive helper functions or modules
- move behavior closer to the data and rules it depends on
- isolate infrastructure concerns behind clearer seams
- consolidate duplicate logic behind one tested implementation
