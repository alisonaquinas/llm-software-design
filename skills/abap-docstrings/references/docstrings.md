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


## ABAP Doc shape

Keep ABAP Doc on the interface declaration that ADT and repository browsers expose.

- Use a short synchronized summary for the declaration that appears in hover help.
- Document public sections of classes and interfaces before protected or private implementation detail.
- Keep importing, exporting, changing, returning, and raising information aligned with the real signature.
- Prefer one truthful summary over a large HTML fragment; richer narrative belongs only where the surrounding toolchain already renders it well.
- When a class or interface is the contract boundary, document the definition section instead of repeating text in every implementation.

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

## Anti-patterns

- documenting only the implementation method while leaving the public class definition undocumented
- letting parameter or exception prose drift away from the actual signature
- using decorative HTML that makes ADT hovers harder to read
- copying synchronized short texts between unrelated declarations without checking meaning
- describing business promises or side effects that the method contract does not actually guarantee

## Reference starting points

- ABAP Development Tools help for ABAP Doc and element information hovers
- SAP style guidance for public class and interface documentation in your landscape
- repository-specific conventions for exception classes, parameter naming, and generated interface docs
