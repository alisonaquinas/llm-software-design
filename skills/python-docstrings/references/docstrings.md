# Python documentation convention

## Preferred convention

PEP 257 docstrings

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer runtime docstrings attached directly to modules, classes, functions, and methods. Preserve an existing NumPy or Google section layout when the codebase already standardizes on it.

## Best targets

public modules, classes, functions, methods, exceptions

## Canonical syntax

```text
def add(a: int, b: int) -> int:
"""Return the sum of two integers."""
return a + b
```

## Example

```text
class Invoice:
"""Represent a customer invoice."""

def total(self) -> float:
    """Return the invoice total after adjustments."""
    ...
```

## External tool access

pydoc, inspect, Sphinx autodoc, IDE help

```text
python -m pydoc package.module
sphinx-apidoc -o docs/api src/
```

## Migration guidance

- convert declaration-adjacent comments incrementally so mixed-style files can be cleaned up safely over time
- avoid mixing competing documentation styles in one file unless a staged migration explicitly requires it
- verify generated docs, IDE help, or extracted metadata after making documentation changes

## Review checklist

- [ ] the chosen convention matches the surrounding toolchain or house style
- [ ] comments are attached to the declarations that external tools inspect
- [ ] summaries describe real behavior without invented guarantees
- [ ] parameters, returns, errors, and examples match the code
- [ ] extraction or verification commands are noted when they materially help review or CI

## Notes

Keep the first line as a one-sentence summary. Add parameters, returns, raises, and examples only when they improve tool output or reviewer clarity.
