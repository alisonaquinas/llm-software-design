# Delphi/Object Pascal documentation convention

## Preferred convention

XML documentation comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer triple-slash XML documentation comments in modern Delphi code because they are source-adjacent, IDE-friendly, and can feed generated API references.

## Best targets

public units, types, methods, properties, records, enums

## Canonical syntax

```text
/// <summary>Add two integers.</summary>
/// <param name="A">Left operand.</param>
/// <param name="B">Right operand.</param>
/// <returns>Sum of the operands.</returns>
function Add(A, B: Integer): Integer;
```

## Example

```text
/// <summary>Build the current report snapshot.</summary>
/// <param name="Request">Immutable report request.</param>
/// <returns>Generated snapshot.</returns>
function Build(const Request: TReportRequest): TReportSnapshot;
```

## External tool access

IDE help, XML doc output, PasDoc-style generators

```text
pasdoc source/*.pas
compiler XMLDoc generation when enabled
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

Comment declarations in interface sections first. Keep narrative implementation commentary separate from exported API documentation.
