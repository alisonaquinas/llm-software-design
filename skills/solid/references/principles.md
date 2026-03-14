# SOLID principle guide

## Core lens

Use SOLID as a set of change-driven heuristics:

- **SRP** helps when one unit mixes unrelated reasons to change.

- **OCP** helps when new variants repeatedly force edits in stable code.

- **LSP** helps when polymorphism exists on paper but callers still need type checks or defensive caveats.

- **ISP** helps when a shared contract is wider than most consumers need.

- **DIP** helps when high-level policy is coupled to volatile I/O, frameworks, transport, storage, or vendor code.

The goal is not doctrinal purity. The goal is cheaper, safer change.

## Practical reading of each principle

### Single Responsibility Principle

**Question to ask:** what independent change requests hit this unit?

A responsibility is not “one method” or “one concept word.” A responsibility is a cohesive reason to change. A unit likely violates SRP when it mixes two or more of these:

- business policy or domain rules

- orchestration or workflow steps

- persistence or transport details

- formatting or presentation concerns

- caching, logging, retry, or other cross-cutting behavior

## Useful refactors

- extract pure policy from I/O-heavy orchestration

- split parsing, validation, and persistence into separate units

- move formatting out of domain objects when the formatting rules change independently

## False positive to avoid

Do not split a small cohesive module just because it has several short helper functions.

### Open/Closed Principle

**Question to ask:** when behavior changes, where do edits accumulate?

OCP matters when variation is real and recurring. Repeated edits to the same `if`/`match`/`switch` branches across call sites often signal the need for a stable extension seam.

## Good extension seams

- strategy objects or callback tables

- registries keyed by a type tag or protocol

- traits, interfaces, or protocol-based adapters

- data-driven tables when behavior differs mostly by configuration

## False positive to avoid

Do not replace one local conditional with an elaborate hierarchy unless the variation is expected to grow.

### Liskov Substitution Principle

**Question to ask:** can callers use the abstraction without knowing the concrete subtype?

A subtype or implementation violates LSP when it weakens guarantees or surprises the caller:

- throws or returns an error for valid base-case operations

- narrows acceptable inputs more than the base contract allows

- changes output invariants, state transitions, or side effects unexpectedly

- requires callers to special-case a subtype before using it

## Useful refactors

- narrow the abstraction so every implementation can honor it fully

- split a wide hierarchy into smaller contracts

- replace inheritance with composition when the “is-a” relationship is weak

### Interface Segregation Principle

**Question to ask:** which consumers are forced to depend on members they never use?

Wide interfaces create accidental coupling, versioning pain, and fake implementations. This is especially visible when test doubles must implement irrelevant methods or when implementations throw “not supported” errors.

## Useful refactors

- split one broad contract into role-based interfaces or traits

- expose read-only and read-write views separately

- separate sync and async interfaces when mixing them creates awkward APIs

### Dependency Inversion Principle

**Question to ask:** which direction do the volatile dependencies point?

High-level policy should depend on stable abstractions. Infrastructure should plug into policy, not the other way around. DIP usually matters at boundaries such as:

- application service → database or HTTP client

- domain logic → queue, clock, filesystem, or environment access

- reusable library → logging, caching, or feature-flag vendor

## Useful refactors

- pass behavior in through interfaces, traits, protocols, callbacks, or function pointers

- keep framework types at the edge and translate them into local abstractions

- centralize object construction in a composition root or explicit factory

## How the principles reinforce each other


- SRP often reveals the right seam for DIP.

- ISP often repairs LSP by shrinking unrealistic contracts.

- OCP works best when duplication has been reduced and variation is explicit.

- DIP and OCP usually pair together: abstractions create the extension seam, and infrastructure implementations extend behavior.

## Common review questions


- which unit changes when a new variant is introduced?

- which dependency is hardest to fake in tests or isolated runs?

- where do callers still know too much about concrete implementations?

- which interface members are ignored, stubbed, or rejected by some implementations?

- which module mixes policy with formatting, transport, storage, or retries?

## Anti-patterns to avoid while “applying SOLID”


- extracting one-interface-per-class with no real alternate implementations

- replacing a clear conditional with a hierarchy that obscures the business rule

- splitting units so aggressively that the collaboration becomes harder to follow than the original code

- mistaking framework dependency injection for DIP; constructor injection alone does not guarantee a good dependency direction

- using inheritance where composition, traits, or module-level functions would be simpler

## Review checklist


- [ ] the concrete change pressure is named before any principle is invoked

- [ ] the recommendation identifies one or two dominant principle violations, not a flat scorecard

- [ ] the proposed seam matches the language and runtime style

- [ ] the refactor improves testability, substitutability, or change isolation without excessive ceremony

- [ ] follow-up verification is stated: characterization tests, contract tests, or integration checks

## Reference starting points

### General


- [SOLID overview](https://deviq.com/principles/solid/)

- [Open-Closed Principle](https://deviq.com/principles/open-closed-principle/)

- [Interface Segregation Principle](https://deviq.com/principles/interface-segregation/)

- [Liskov Substitution Principle](https://deviq.com/principles/liskov-substitution-principle/)

### Language-specific references


- Python: [PEP 544 protocols](https://peps.python.org/pep-0544/), [typing protocols reference](https://typing.python.org/en/latest/reference/protocols.html), [contextlib](https://docs.python.org/3/library/contextlib.html)

- TypeScript: [interfaces](https://www.typescriptlang.org/docs/handbook/interfaces.html), [strict](https://www.typescriptlang.org/tsconfig/strict.html), [unions and intersections](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html)

- JavaScript: [MDN JavaScript modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules), [MDN classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes), [MDN functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions)

- C: [SEI CERT C coding standard](https://www.sei.cmu.edu/downloads/sei-cert-c-coding-standard-2016-v01.pdf), [MEM12-C cleanup guidance](https://wiki.sei.cmu.edu/confluence/display/c/MEM12-C.%2BConsider%2Busing%2Ba%2Bgoto%2Bchain%2Bwhen%2Bleaving%2Ba%2Bfunction%2Bon%2Berror%2Bwhen%2Busing%2Band%2Breleasing%2Bresources)

- C++: [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/)

- C#: [C# interfaces](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/interfaces), [interface design guidelines](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/interface), [dependency injection guidelines](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection/guidelines)

- Rust: [The Rust Book: traits](https://doc.rust-lang.org/book/ch10-02-traits.html), [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/checklist.html), [object-safe traits](https://rust-lang.github.io/api-guidelines/flexibility.html)
