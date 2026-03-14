# Python documentation convention

## Preferred convention

PEP 257 docstrings

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code
- preserve Google-style or NumPy-style section layouts when the repository already uses them consistently

## Why this is the default

Python stores docstrings directly on modules, classes, functions, and methods, which makes them discoverable at runtime through `help()`, `pydoc`, `inspect.getdoc`, IDE hover help, and documentation generators. PEP 257 standardizes the structure and tone of those docstrings without forcing one particular section markup style.

## Best targets

- public modules and packages
- public classes, dataclasses, exceptions, and protocols
- public functions, methods, properties, and descriptors
- command entry points or extension hooks that external callers rely on

## Structural expectations

### One-line docstrings

Use a short imperative or descriptive summary when the symbol is simple.

```text
def add(a: int, b: int) -> int:
    """Return the sum of two integers."""
    return a + b
```

### Multi-line docstrings

Use a one-line summary first, then a blank line, then details that help the toolchain or reviewer.

Typical follow-on content:

- parameters and accepted value shapes
- return semantics
- raised exceptions when callers need to handle them
- side effects, mutation, or I/O behavior
- examples that actually match the implementation

## Format selection

PEP 257 governs structure, not field syntax. Use the field style already present in the repository:

- **Plain narrative** for smaller internal codebases.
- **Google style** when tooling or linters expect `Args:`, `Returns:`, and `Raises:` sections.
- **NumPy style** when scientific or data-oriented projects already use `Parameters` and `Returns` tables.

Do not mix those section styles within the same file unless a staged migration explicitly requires it.

## Canonical patterns

### Function

```text
def build_report(request: ReportRequest) -> ReportSnapshot:
    """Build the current report snapshot.

    Args:
        request: Immutable report request.

    Returns:
        Generated report snapshot.

    Raises:
        ValueError: If the request is internally inconsistent.
    """
```

### Class

```text
class Invoice:
    """Represent a customer invoice.

    The object keeps line items and exposes total calculations but does not
    persist itself.
    """
```

### Property

```text
@property
def total(self) -> Decimal:
    """Return the invoice total in billing currency."""
```

## External tool access

Python docstrings are consumed directly by runtime and doc-generation tools.

```text
python -m pydoc package.module
python -c "import inspect, package.module as m; print(inspect.getdoc(m.Symbol))"
sphinx-apidoc -o docs/api src/
```

## Migration guidance

- convert declaration-adjacent comments incrementally so mixed-style files can be cleaned up safely over time
- move detached block comments into real docstrings on the symbols that tools inspect
- prefer documenting the public surface first, then high-value internal helpers only when needed
- verify generated docs, IDE help, or extracted metadata after making documentation changes

## Review checklist

- [ ] The chosen section style matches the surrounding toolchain or house style.
- [ ] Comments are attached to the declarations that external tools inspect.
- [ ] The first line is a truthful one-sentence summary.
- [ ] Parameters, return values, raised exceptions, and examples match the real code.
- [ ] Docstrings describe observable behavior, not aspirational behavior.
- [ ] Examples are runnable or close enough to be checked mechanically.

## Anti-patterns

- repeating the function signature in prose when the language already shows it
- documenting private implementation trivia that callers cannot observe
- claiming thread safety, performance guarantees, or exceptions that the code does not actually provide
- copying examples that no longer match the real API
- mixing Google, NumPy, and ad hoc section styles in the same file without a migration plan

## Reference starting points

- [PEP 257](https://peps.python.org/pep-0257/)
- [PEP 8](https://peps.python.org/pep-0008/)
- [pydoc](https://docs.python.org/3/library/pydoc.html)
- [inspect.getdoc](https://docs.python.org/3/library/inspect.html)
