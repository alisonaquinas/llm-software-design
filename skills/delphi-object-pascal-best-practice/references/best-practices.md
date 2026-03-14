# Delphi/Object Pascal best practices

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

- Keep units cohesive, names descriptive, and interface sections small enough to communicate the module contract quickly.
- Make ownership and lifetime rules explicit, especially when mixing classic object ownership, interfaces, and manual cleanup.
- Prefer clear classes, records, and helper abstractions over global state or form-bound business logic.
- Use language and library features deliberately instead of emulating patterns from unrelated ecosystems.
- Adopt one formatting profile and automate compilation and tests across supported targets.

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

- [Delphi Object Pascal Style Guide](https://docwiki.embarcadero.com/RADStudio/Florence/en/Delphi%E2%80%99s_Object_Pascal_Style_Guide)
- [Delphi Language Guide](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Delphi_Language_Guide_Index)
