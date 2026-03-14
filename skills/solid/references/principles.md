# Principle checklist

## Core lens

Use SOLID to explain changeability, substitution safety, interface shape, and dependency direction. Focus on the principle that best explains the current problem instead of forcing a full-scorecard review when only one area is weak.

## Principle-by-principle guidance

- **Single Responsibility Principle**: one reason to change per unit; split responsibilities when policy, orchestration, and infrastructure are entangled.
- **Open/Closed Principle**: extend behavior through composition, policy, or strategy rather than repeated conditional edits across call sites.
- **Liskov Substitution Principle**: derived types should preserve base expectations for invariants, errors, and observable effects.
- **Interface Segregation Principle**: consumers should not depend on methods, events, or properties they do not use.
- **Dependency Inversion Principle**: high-level policy should depend on stable abstractions, not volatile delivery or storage details.

## Review checklist

- [ ] the dominant reason the code is hard to change is clearly stated
- [ ] each finding is tied to a concrete responsibility, dependency, or substitution issue
- [ ] recommendations avoid unnecessary interfaces, base classes, or indirection
- [ ] the proposed refactor preserves behavior while improving testability or clarity
- [ ] follow-up validation steps are identified

## Common refactor moves

- extract policy from orchestration or I/O code
- replace repeated conditionals with composition or dispatch when the variability is real and recurring
- split wide interfaces around consuming roles
- invert dependencies at module boundaries where infrastructure volatility is high
