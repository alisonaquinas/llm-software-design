# Assembly language best practices

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

- Identify the target ISA, assembler syntax, object format, ABI, and calling convention before recommending any change.
- Keep assembly isolated to the smallest performance-critical or hardware-critical surface possible.
- Comment register ownership, stack layout, clobbers, and non-obvious invariants directly next to the code that depends on them.
- Prefer labels, named constants, and macros that improve readability; avoid abstraction that obscures instruction flow.
- Cross-check behavior with disassembly, ABI rules, and focused tests rather than relying on visual inspection alone.

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

- [GNU assembler manual](https://sourceware.org/binutils/docs/as/)
- [System V AMD64 psABI](https://gitlab.com/x86-psABIs/x86-64-ABI)
- [AAPCS64](https://github.com/ARM-software/abi-aa/releases)
