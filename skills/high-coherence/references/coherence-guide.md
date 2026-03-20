# Coherence guide

## What coherence means

High coherence means the system presents a consistent design story from domain language to module boundaries to runtime behavior. The strongest review question is whether a local change can stay inside the boundary that appears to own the concept.

## Four levels to review

### Conceptual coherence

- keep one shared term for one business concept
- avoid parallel abstractions that model the same thing differently
- prune duplicate ideas before introducing new framework or service boundaries

### Module coherence

- keep related behavior together and reasons to change focused
- watch for god modules, feature envy, shotgun surgery, and unrelated dependencies in one class or package
- prefer responsibility-focused seams over process-step decomposition

### Architectural coherence

- make dependency direction explicit
- prevent cycles across layers, slices, modules, or services
- keep shared databases, hidden side channels, and bypass paths intentional and rare

### Runtime coherence

- inspect real call paths, shared resources, and deployment coordination
- treat must-deploy-together paths and long synchronous chains as coherence defects
- align operational reality with the intended architecture, not only the diagram

## High-leverage interventions

- define a small set of architectural rules and make them testable
- record significant boundary decisions in lightweight ADRs
- align team ownership with the boundaries expected to change independently
- refactor toward change vectors and volatile decisions, not only surface structure
- monitor drift with cycle counts, cross-boundary churn, and deployment coupling

## Review checklist

- [ ] the main concepts and invariants have one clear owner
- [ ] names and models stay consistent across modules and APIs
- [ ] dependency rules are explicit and reviewable
- [ ] runtime behavior matches the intended structure
- [ ] governance is light but continuous
