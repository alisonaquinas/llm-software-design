# JavaScript best practices

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

- Prefer `const` and `let`, explicit module boundaries, and descriptive names over mutation-heavy scripts and implicit globals.
- Use `async` and `await` or disciplined promise chains; make error propagation explicit and avoid swallowed rejections.
- Keep data validation at API and I/O boundaries so dynamic typing remains manageable.
- Choose one formatter and one lint profile for the repository; avoid stylistic drift between browser and server code.
- Test behavior close to module boundaries and isolate time, randomness, and external effects behind thin adapters.

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

- [MDN JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
