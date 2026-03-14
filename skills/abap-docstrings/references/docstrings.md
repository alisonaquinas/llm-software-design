# ABAP documentation convention

## Preferred convention

ABAP Doc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer ABAP Doc because it is the native source documentation format for modern ABAP development tools and keeps API descriptions tied to class and interface elements.

## Best targets

public classes, interfaces, methods, parameters, exception contracts

## Canonical syntax

```text
"! <p class="shorttext synchronized">Add two integers.</p>
METHODS add
  IMPORTING a TYPE i
        b TYPE i
  RETURNING VALUE(result) TYPE i.
```

## Example

```text
"! <p class="shorttext synchronized">Build the current report snapshot.</p>
METHODS build
  IMPORTING request TYPE zreport_request
  RETURNING VALUE(report) TYPE zreport_snapshot.
```

## External tool access

ABAP Development Tools, generated interface docs, repository browsers

```text
ADT hover help and generated class interface docs
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

Document the public interface in class definitions rather than repeating prose in method implementations.
