# Fortran best practices

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

- Prefer modules, explicit interfaces, `implicit none`, and named intents over legacy implicit behavior.
- Move logic into procedures and functions instead of long top-level program bodies or common-block style state.
- Be explicit about array shapes, allocation, numerical precision, and parallel assumptions.
- Keep I/O, numeric kernels, and orchestration separate so performance work does not pollute domain clarity.
- Use modern build and test tooling where possible, and keep compiler warnings enabled across supported compilers.

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

- [Fortran Best Practices](https://fortran-lang.org/learn/best_practices/)
- [Fortran Style Guide](https://fortran-lang.org/learn/best_practices/style_guide/)
