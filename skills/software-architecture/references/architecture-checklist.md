# Architecture checklist

## Primary drivers

Capture the forces that matter before comparing structures: scale profile, team ownership, reliability goals, compliance constraints, deploy cadence, integration surface, and data consistency needs.

## Boundary heuristics

- what must change independently?
- which teams or owners need clear boundaries?
- which dependencies are stable versus volatile?
- what data should stay strongly consistent versus eventually consistent?
- where does latency or failure isolation materially change the design?

## Common architectural choices

- **modular monolith** when deploy simplicity matters and boundaries can stay strong inside one runtime
- **services** when independent scaling, ownership, or release cadence clearly outweigh operational overhead
- **event-driven integration** when decoupled reactions and temporal separation matter more than immediate consistency
- **layered architecture** when policies, use cases, and delivery mechanisms need clean dependency direction

## Review checklist

- [ ] the main drivers are explicit before the recommendation is made
- [ ] proposed boundaries align with ownership and change frequency
- [ ] integration style, data consistency, and failure modes are named explicitly
- [ ] operational cost is weighed alongside flexibility benefits
- [ ] the recommendation includes signals that would justify future evolution

## Typical follow-through

- define seams and contracts before moving runtime boundaries
- keep cross-boundary calls and shared schemas intentional
- favor incremental migration paths over big-bang rewrites
