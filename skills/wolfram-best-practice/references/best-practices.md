# Wolfram best practices

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

- Separate exploratory notebook work from reusable package code once behavior stabilizes.
- Use meaningful symbols, explicit contexts, and carefully scoped pattern rules to avoid accidental collisions.
- Prefer clear functional and rule-based transformations over deeply nested notebook-side procedural code when that improves intent.
- Document assumptions about evaluation order, held arguments, and symbolic versus numeric behavior.
- Add verification tests for functions that will survive beyond a single notebook session.

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

- [Wolfram Language code style guidelines](https://www.wolfram.com/language/fast-introduction-for-programmers/en/code-style-guidelines/)
- [Wolfram package bullet guide](https://reference.wolfram.com/language/guide/WolframLanguagePackages.html)
