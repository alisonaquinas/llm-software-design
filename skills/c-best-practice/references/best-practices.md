# C best practices

## Scope

- Start by confirming the compiler, interpreter, runtime, vendor, or dialect when that changes the advice.
- Prefer project-local conventions when they are already automated and internally consistent.
- Use the defaults below when the repository has no clear standard.

## Review priorities

- identify correctness and behavior-preservation constraints before recommending stylistic cleanup
- prefer conventions that make ownership, dependencies, and change seams easier to understand
- keep project-local standards when they are already automated and internally consistent
- distinguish language defaults from framework, vendor, or deployment-specific rules

## Generally accepted defaults

- Keep ownership, lifetime, and mutability obvious; document buffer sizes, invariants, and aliasing assumptions at boundaries.
- Prefer narrow headers, explicit initialization, checked return values, and symbolic constants instead of magic numbers.
- Compile with aggressive warnings and treat warning cleanup, undefined behavior avoidance, and portability as first-class work.
- Use sanitizers and focused tests for parsing, memory management, and error paths; fuzz externally facing inputs when practical.
- Adopt one formatting profile and one naming scheme per repository so low-level code remains grep-friendly.

## Common tooling and automation

- standardize formatting, linting, and test execution so the review guidance is easy to apply in CI
- prefer repeatable commands, config files, and compiler or interpreter flags over per-developer IDE habits
- pair language-level recommendations with concrete verification steps when behavior or portability could change

## Review checklist

- [ ] The version, dialect, or host runtime is identified before advice becomes specific.
- [ ] Naming, layout, and public API shape are internally consistent.
- [ ] Error handling and boundary validation are explicit.
- [ ] Tests or executable examples cover important edge cases.
- [ ] Formatting, linting, and static analysis are easy to run in CI.

## Typical follow-through

- recommend the smallest set of edits that materially improves clarity, safety, or maintainability
- include tests, examples, or commands that verify the refactor did not change behavior unintentionally
- separate style advice from correctness, performance, portability, or reliability concerns

## Reference starting points

- [SEI CERT C Coding Standard](https://wiki.sei.cmu.edu/confluence/display/c)
- [clang-format style options](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)
