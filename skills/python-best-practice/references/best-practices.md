# Python best practices

## Scope

- Start by confirming the Python version, runtime, packaging model, and deployment target before giving specific guidance.
- Distinguish library code, application code, notebooks, scripts, build tooling, and framework code because their tradeoffs differ.
- Prefer project-local conventions when they are already automated and internally consistent.
- Use the defaults below when the repository has no clear standard.

## Version and ecosystem gates

Confirm these first because they materially change the recommendations:

- **Runtime**: CPython, PyPy, MicroPython, embedded Python, or a vendor-patched runtime.
- **Version floor**: typing, pattern matching, `pathlib`, `tomllib`, `ExceptionGroup`, and packaging guidance all shift by version.
- **Execution model**: sync, async, multiprocessing, data-science workflow, CLI, or long-running service.
- **Artifact type**: reusable package, internal service, desktop app, Lambda or serverless function, or one-off automation.

## Review priorities

- identify correctness and behavior-preservation constraints before recommending stylistic cleanup
- prefer conventions that make ownership, dependencies, and change seams easier to understand
- keep project-local standards when they are already automated and internally consistent
- distinguish language defaults from framework, vendor, or deployment-specific rules
- treat packaging, import discipline, and testability as part of design rather than afterthoughts

## Default design choices

### Modules and package structure

- Prefer packages and modules with a single clear responsibility instead of large script-like files.
- Keep import side effects minimal; module import should usually define names, not perform work.
- Put process startup in a small entry point such as `if __name__ == "__main__":` or a dedicated CLI module.
- Keep public API surfaces explicit with clear exports and stable import paths.

### Typing posture

- Add type hints at public boundaries, protocol boundaries, and non-trivial business logic.
- Prefer precise domain types, `TypedDict`, `Protocol`, `Enum`, and `dataclass` models over anonymous dictionaries when the shape matters.
- Avoid type noise in obvious locals when inference is already clear.
- Prefer `None`-aware signatures, explicit optionality, and narrow return types instead of sentinel-heavy APIs.
- Treat type checking as design feedback: if types are hard to express, the API may be doing too much.

### State and mutability

- Prefer simple data flow and explicit dependencies over module globals and hidden singletons.
- Keep mutable shared state narrow and visible.
- Use immutable tuples, frozen dataclasses, or value objects when they clarify invariants.
- Be deliberate with default arguments; never use mutable defaults for accumulators or caches.

### Errors and resource handling

- Raise specific exceptions that communicate the failed contract.
- Catch exceptions at boundaries where the code can add context, translate the error, retry, or recover.
- Avoid broad `except Exception` unless the boundary is explicitly a last-resort logging or process-control layer.
- Prefer context managers for files, sockets, locks, transactions, and temporary resources.
- Keep cleanup deterministic; do not rely on reference counting side effects for correctness.

### Data access and I/O

- Validate external inputs near the edge.
- Keep serialization, deserialization, parsing, environment access, and network calls behind small seams that are easy to test.
- Separate pure transformation logic from effectful adapter code.
- Be cautious with implicit timezone handling, locale-sensitive formatting, and text vs bytes boundaries.

## Tooling baseline

Use one coherent automation path instead of per-developer habits.

| Concern | Preferred baseline |
| --- | --- |
| formatting and linting | one repository-wide formatter and linter profile, commonly `ruff` with formatting enabled or `black` plus a linter |
| imports | automate ordering and unused-import cleanup; do not hand-maintain large import blocks |
| type checking | run `mypy`, `pyright`, or another checker in CI for the typed surface |
| tests | use `pytest`-style tests with fast unit coverage and explicit fixtures |
| packaging | centralize metadata and tool config in `pyproject.toml` where practical |
| docs | keep docstrings compatible with the selected extraction flow such as `pydoc` or Sphinx |

## Common red flags

- script-style modules that mix parsing, I/O, orchestration, and business logic in one file
- hidden mutation through module globals, caches, or monkey-patching
- broad exception suppression that loses the original failure cause
- stringly-typed dictionaries passed through many layers without validation
- duplicated path manipulation or environment lookup logic scattered across the codebase
- tests that require network, real clocks, or shared mutable state when a seam would make them deterministic

## Review checklist

- [ ] The runtime, version floor, and deployment model are identified before advice becomes specific.
- [ ] Public functions, classes, and modules have clear names and focused responsibilities.
- [ ] Type hints are present where they improve contracts, not merely for decoration.
- [ ] Error handling is specific, observable, and located at the right boundaries.
- [ ] Resource management uses context managers or equally explicit cleanup.
- [ ] Tests cover the important edge cases, especially parsing, boundary validation, and error paths.
- [ ] Formatting, linting, and type checks are easy to run locally and in CI.

## Migration playbook

- standardize tooling first so later code review guidance is cheap to enforce
- move effectful startup and environment access toward dedicated entry points
- add types at public boundaries before filling in every private helper
- replace broad exceptions and hidden globals before chasing cosmetic style issues
- introduce small focused tests around the behavior being preserved, then refactor confidently

## Reference starting points

- [PEP 8](https://peps.python.org/pep-0008/)
- [PEP 257](https://peps.python.org/pep-0257/)
- [Python Style Guide essay](https://www.python.org/doc/essays/styleguide/)
- [Python documentation](https://docs.python.org/3/)
