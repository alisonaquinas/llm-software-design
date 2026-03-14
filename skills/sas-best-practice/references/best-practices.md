# SAS best practices

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

- Keep data steps, procedures, and macros readable with consistent naming, layout, and section structure.
- Use macros where parameterization pays off; avoid wrapping constant text in macros when `%include` or ordinary code is clearer.
- Check logs for warnings, implicit conversions, truncation, and sort assumptions as part of routine quality work.
- Make datasets, libraries, and temporary artifacts descriptively named so batch pipelines remain traceable.
- Separate reusable transformations from job orchestration and document external dependencies.

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

- [Best-Practice Programming Techniques Using SAS](https://support.sas.com/resources/papers/proceedings17/0175-2017.pdf)
- [Writing Efficient and Portable Macros](https://support.sas.com/documentation/cdl/en/mcrolref/59526/HTML/default/a001328810.htm)
