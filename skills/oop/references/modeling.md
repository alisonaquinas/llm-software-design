# Modeling guide

## Core lens

Model around responsibilities, invariants, and lifecycles. Good object design keeps the data that must stay consistent close to the behavior that enforces those rules.

## Useful distinctions

- **Entity**: identity matters across time; lifecycle and mutation are meaningful.
- **Value object**: equality is by value; behavior often centers on validation, formatting, or domain rules.
- **Service or policy object**: behavior coordinates multiple collaborators or applies logic that does not belong to one entity.
- **Boundary object**: translates between the domain and external systems, requests, persistence, or UI.

## Collaboration questions

- which object owns the invariant that must stay true?
- which object has the information needed to decide?
- which object should trigger the next collaborator on the main path?
- where does state live today, and is the behavior that mutates it nearby?

## Review checklist

- [ ] major concepts are represented at the right level of abstraction
- [ ] responsibilities are cohesive inside each object or module
- [ ] domain behavior is not stranded in controllers, handlers, or utility classes
- [ ] collaborations are explicit and understandable on the main use case path
- [ ] inheritance is justified by substitutability rather than convenience

## Common improvements

- move validation or rule enforcement closer to the state it protects
- introduce value objects when primitive fields repeatedly travel together with rules
- split orchestration from domain behavior when one type is doing both
- collapse needless wrappers when they add no real responsibility or boundary value
