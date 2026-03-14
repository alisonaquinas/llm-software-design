# Transact-SQL best practices

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

- Design for set-based processing first and reach for cursors only when the data shape truly requires them.
- Make transaction scope, error handling, and retry semantics explicit in stored procedures and migration scripts.
- Use clear object names, explicit schema qualification, and predictable deployment ordering.
- Inspect query plans and indexes before applying hints or denormalization; performance advice must match workload reality.
- Keep admin-only patterns separate from application-facing routines.

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

- [SQL Server documentation](https://learn.microsoft.com/en-us/sql/t-sql/language-reference)
- [Policy-based best practices](https://learn.microsoft.com/en-us/sql/relational-databases/policy-based-management/monitor-and-enforce-best-practices-by-using-policy-based-management)
