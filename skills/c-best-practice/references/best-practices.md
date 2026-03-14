# C best practices

## Scope

- Start by confirming the C standard level, compiler family, and target environment before giving specific guidance.
- Distinguish hosted vs freestanding builds, embedded vs desktop/server targets, and POSIX vs Windows APIs because those constraints dominate design choices.
- Prefer project-local conventions when they are already automated and internally consistent.
- Use the defaults below when the repository has no clear standard.

## Version and platform gates

Confirm these first because they materially change the recommendations:

- **Language floor**: C89, C99, C11, C17, or C23.
- **Environment**: hosted runtime, freestanding or embedded target, kernel code, firmware, or userspace service.
- **Compiler family**: GCC, Clang, MSVC, or vendor toolchain.
- **Availability of tooling**: sanitizers, static analyzers, fuzzers, and unit-test harnesses are not equally available everywhere.

## Review priorities

- identify correctness and behavior-preservation constraints before recommending stylistic cleanup
- prefer conventions that make ownership, dependencies, and change seams easier to understand
- keep project-local standards when they are already automated and internally consistent
- distinguish language defaults from platform-specific policy and ABI constraints
- treat undefined behavior avoidance, integer correctness, and bounds management as core design work

## Default design choices

### Headers and interfaces

- Keep headers narrow, include only what is required, and document ownership and buffer expectations at the boundary.
- Prefer declarations that make mutability visible, such as `const` parameters where appropriate.
- Avoid exposing unnecessary macros, internal struct layout, or transitive dependency clutter in public headers.
- Use symbolic constants, enums, or dedicated types instead of magic numbers.

### Lifetime and ownership

- Make allocation, deallocation, and borrowing explicit.
- Prefer one obvious owner for each resource.
- Document whether the callee borrows, takes ownership, or writes into caller-provided storage.
- Prefer APIs that accept buffer pointer plus size together; avoid size assumptions hidden in comments alone.

### Undefined behavior and portability

- Treat warnings, integer conversions, aliasing assumptions, and signedness mismatches as design issues, not cosmetic issues.
- Initialize objects deliberately.
- Be careful with pointer provenance, strict aliasing, integer overflow, alignment, and lifetime rules.
- Prefer standard library facilities and portable idioms before compiler-specific tricks.
- When platform-specific code is necessary, isolate it behind a small interface.

### Macros and inline code

- Use macros primarily where the preprocessor is genuinely required.
- Prefer `static inline` functions over function-like macros when type safety and debuggability matter.
- Parenthesize macro parameters and results carefully when macros are unavoidable.
- Avoid macros with hidden control flow or double-evaluation hazards.

## Tooling baseline

| Concern | Preferred baseline |
| --- | --- |
| warnings | compile with aggressive warnings and keep the warning baseline clean |
| static analysis | run at least one analyzer in CI when the environment allows it |
| runtime checking | enable AddressSanitizer and UndefinedBehaviorSanitizer where supported |
| formatting | keep one `clang-format` or equivalent style profile |
| tests | add focused unit tests and property or fuzz testing around parsing and memory-sensitive code |

## Common red flags

- APIs that accept raw pointers without size, ownership, or mutability contracts
- unchecked return values from allocation, parsing, I/O, or synchronization calls
- integer narrowing or sign conversion without a visible reason
- buffer length assumptions stored only in the caller's head
- macros that evaluate arguments more than once or hide side effects
- platform-dependent behavior leaking through supposedly portable interfaces

## Review checklist

- [ ] The C standard level, compiler family, and target environment are identified before advice becomes specific.
- [ ] Ownership, borrowing, and buffer-size expectations are explicit at the boundary.
- [ ] Warnings, sanitizer findings, and static-analysis output are treated as meaningful signals.
- [ ] Public headers are small, stable, and free of avoidable transitive clutter.
- [ ] Integer conversions, aliasing assumptions, and error paths are reviewed intentionally.
- [ ] Tests or fuzzing cover parsing, allocation failure, and boundary conditions where practical.

## Migration playbook

- enable and clean up warnings before arguing over formatting trivia
- document ownership and buffer contracts at public interfaces before deeper refactors
- isolate platform-specific code and undefined-behavior hazards behind small seams
- replace dangerous macros with `static inline` functions where behavior must stay the same
- add sanitizer-backed tests around the code you are about to simplify

## Reference starting points

- [C reference](https://en.cppreference.com/w/c)
- [SEI CERT C Coding Standard](https://wiki.sei.cmu.edu/confluence/display/c)
- [Doxygen documentation blocks](https://www.doxygen.nl/manual/docblocks.html)
