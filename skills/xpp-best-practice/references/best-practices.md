# X++ best practices

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

- Write extensible code with clean public and protected methods rather than large inline workflows.
- Keep transaction scope narrow and obvious, especially around `ttsbegin` and `ttscommit` boundaries.
- Separate persistence, validation, and orchestration logic so chain-of-command or event extensions stay reliable.
- Prefer descriptive names and reusable classes over duplicated form or table method logic.
- Match guidance to the Dynamics 365 extensibility model in use rather than generic object-oriented advice alone.

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

- [Writing extensible code in X++](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/extensibility/writing-extensible-code)
- [X++ language reference](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/dev-ref/xpp-language-reference)
