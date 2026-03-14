# Ladder Logic best practices

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

- Confirm the PLC vendor, IEC 61131-3 environment, and safety constraints before suggesting structural changes.
- Optimize rungs for technician readability: descriptive tags, obvious scan flow, and comments that explain machine intent.
- Prefer clear seal-in, permissive, and interlock patterns over dense rung compression.
- Separate startup, sequence control, alarm handling, and device logic into predictable sections or programs.
- Validate with simulation, hardware interlocks, and regression testing around state transitions and fault recovery.

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

- [PLCopen guidelines](https://plcopen.org/guidelines/guidelines)
- [PLCopen coding guidelines](https://plcopen.org/downloads/plcopen-coding-guidelines-version-10)
- [PLCopen logic / IEC 61131-3 overview](https://plcopen.org/technical-activities/logic)
