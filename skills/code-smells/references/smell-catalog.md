# Code smell catalog and triage guide

## Core lens

A code smell is a surface signal that change is becoming risky, expensive, or confusing. Smells are not bugs by themselves. They are cues to look for a deeper design problem, misplaced responsibility, or missing abstraction.

## Smells that usually matter most

### Duplicated logic

## Symptoms

- similar branches, formulas, regexes, SQL fragments, or state transitions in several places
- multiple edits required for one policy change

## Why it matters

Duplication causes policy drift and inconsistent bug fixes.

## Safe first move

Identify the shared knowledge first, then centralize it behind one function, one data table, or one reusable module.

### Long method or long function

## Symptoms

- one block mixes validation, selection, I/O, formatting, and error handling
- many temporary variables or nested branches are needed to understand control flow

## Why it matters

Long methods hide responsibilities and make change-scoping hard.

## Safe first move

Extract coherent steps with names that expose intent. If extraction is hard, that is usually useful diagnostic feedback.

### Large class or large module

## Symptoms

- many dependencies, broad public surface, or unrelated groups of methods
- high edit frequency from unrelated change requests

## Why it matters

Large units concentrate change risk and create ownership confusion.

## Safe first move

Split by responsibility, not by line count. Separate domain rules from transport, storage, or presentation code.

### Shotgun surgery

## Symptoms

- one requirement change forces many scattered edits
- tests fail across unrelated directories for a simple behavior change

## Why it matters

The real business rule has no single home.

## Safe first move

Find the shared concept and move it behind one seam.

### Divergent change

## Symptoms

- the same file changes for many unrelated reasons
- a class owns data rules, rendering, persistence, and workflow coordination

## Why it matters

This is often the mirror image of shotgun surgery.

## Safe first move

Separate the responsibilities that evolve independently.

### Hidden dependencies

## Symptoms

- global variables, statics, implicit environment reads, service locators, singleton access, or ambient transactions
- code that is hard to test because collaborators are discovered indirectly

## Why it matters

Hidden dependencies blur control flow and make behavior context-sensitive.

## Safe first move

Make important collaborators explicit through parameters, constructor injection, small traits, or module-level adapters.

### Primitive obsession and magic values

## Symptoms

- free-form strings, integers, booleans, or maps stand in for domain concepts
- repeated validation of the same shape or sentinel values

## Why it matters

Important invariants live only in scattered conditionals.

## Safe first move

Introduce a focused type, enum, record, or validated wrapper for the concept.

### Data clumps and long parameter lists

## Symptoms

- the same group of arguments travels together repeatedly
- positional parameters are easy to mix up

## Why it matters

Missing concepts make APIs noisy and error-prone.

## Safe first move

Bundle the cohesive data into one typed object or struct.

### Feature envy

## Symptoms

- one function repeatedly drills through another object’s data to make decisions
- a method seems to know more about another type’s invariants than its own type’s state

## Why it matters

Behavior is far from the data and rules it depends on.

## Safe first move

Move the behavior closer to the data or expose a higher-level method on the owning type.

### Inheritance abuse or fake polymorphism

## Symptoms

- callers still switch on runtime type after receiving a base abstraction
- some implementations throw “not supported” for base operations

## Why it matters

The abstraction is dishonest, and LSP is likely broken.

## Safe first move

Shrink the abstraction, split the interface, or replace inheritance with composition.

## Smells that are often secondary symptoms

- comments that explain confusing control flow rather than domain intent
- wide test setup duplicated because production seams are poor
- excessive null checks or option plumbing because invalid states are representable
- logging and metrics scattered through business logic because cross-cutting concerns have no single home
- repeated `switch` or `match` over the same type tag because variation is not centralized

## Triage order

1. start with smells that make safe change hardest today
2. prefer smells tied to real change pain over smells found by static inspection alone
3. separate root-cause smells from downstream symptoms
4. prefer refactors that improve understanding and test seams simultaneously
5. delay purely aesthetic cleanup until structural issues are under control

## Smells versus acceptable tradeoffs

A smell may be acceptable when:

- the code is stable and unlikely to change
- the local duplication is temporary and still below the rule-of-three threshold
- the abstraction needed to remove the smell would be more complicated than the duplication
- performance or interoperability constraints justify a less elegant shape

Document that tradeoff explicitly rather than pretending the smell is not there.

## Review checklist

- [ ] each smell is tied to a concrete maintenance or defect risk
- [ ] the strongest smells are prioritized rather than listed flatly
- [ ] root-cause smells are separated from cosmetic issues
- [ ] recommendations favor behavior-preserving steps where possible
- [ ] characterization or regression tests are identified before deeper cleanup
- [ ] the first refactor step reduces risk for subsequent work

## Reference starting points

### General

- [Martin Fowler: Code Smell](https://martinfowler.com/bliki/CodeSmell.html)
- [Martin Fowler: Refactoring the video store example](https://martinfowler.com/articles/refactoring-video-store-js/)
- [DRY principle](https://deviq.com/principles/dont-repeat-yourself/)

### Language and tooling references

- Python: [PEP 8](https://peps.python.org/pep-0008/), [contextlib](https://docs.python.org/3/library/contextlib.html)
- TypeScript: [strict](https://www.typescriptlang.org/tsconfig/strict.html), [interfaces](https://www.typescriptlang.org/docs/handbook/interfaces.html)
- JavaScript: [MDN modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules), [MDN classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes)
- C: [SEI CERT C coding standard](https://www.sei.cmu.edu/downloads/sei-cert-c-coding-standard-2016-v01.pdf), [MEM12-C cleanup guidance](https://wiki.sei.cmu.edu/confluence/display/c/MEM12-C.%2BConsider%2Busing%2Ba%2Bgoto%2Bchain%2Bwhen%2Bleaving%2Ba%2Bfunction%2Bon%2Berror%2Bwhen%2Busing%2Band%2Breleasing%2Bresources)
- C++: [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/)
- C#: [interface design](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/interface), [dependency injection guidelines](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection/guidelines)
- Rust: [The Rust Book: traits](https://doc.rust-lang.org/book/ch10-02-traits.html), [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/checklist.html), [Clippy lints](https://rust-lang.github.io/rust-clippy/master/)
