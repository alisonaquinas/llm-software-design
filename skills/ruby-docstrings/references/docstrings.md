# Ruby documentation convention

## Preferred convention

YARD comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer YARD because it is the dominant machine-readable Ruby API documentation convention and supports tags, types, and generated reference sites.

## Best targets

public classes, modules, methods, constants, DSL entry points

## Canonical syntax

```text
# Add two integers.
# @param a [Integer] left operand
# @param b [Integer] right operand
# @return [Integer] sum of the operands
def add(a, b)
  a + b
end
```

## Example

```text
# Build the current report snapshot.
# @param request [ReportRequest] immutable report request
# @return [ReportSnapshot] generated snapshot
def build(request)
  ...
end
```

## External tool access

YARD, IDEs, generated API sites

```text
yard doc
yard server --reload
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

Use explicit tags for parameters and return values when the method contract is not obvious from naming alone.
