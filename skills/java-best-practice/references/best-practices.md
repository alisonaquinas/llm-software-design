# Java best practices

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

- Favor small cohesive classes, immutable value objects, and clear package boundaries instead of utility-heavy god modules.
- Keep null-handling, exceptions, and resource management explicit; use `try-with-resources` and specific exception types.
- Use generics and collections idiomatically; avoid raw types, ad hoc casting, and incidental mutability in public APIs.
- Prefer constructor or framework-managed dependency injection over hidden singletons and static state.
- Standardize formatting, static analysis, and test execution in the build so contributors do not rely on IDE defaults alone.

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

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Oracle Java naming conventions](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html)
