# Kotlin best practices

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

- Follow Kotlin coding conventions for file layout, names, and declaration order, especially in mixed Kotlin/Java codebases.
- Use null-safety, sealed types, data classes, and extension functions to simplify API design without hiding behavior.
- Prefer immutable state and structured concurrency with clear coroutine scopes and cancellation.
- Make public API types explicit and document behavior that crosses JVM, Android, or multiplatform boundaries.
- Keep formatting, static analysis, and tests automated in CI.

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

- [Kotlin coding conventions](https://kotlinlang.org/docs/coding-conventions.html)
- [Kotlin API guidelines](https://kotlinlang.org/docs/api-guidelines-introduction.html)
