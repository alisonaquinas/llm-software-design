# Classic Visual Basic documentation convention

## Preferred convention

structured header comments for VBDOX-style tools

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer stable structured header comments because classic Visual Basic lacks a native compiler-emitted documentation system and external tools generally parse predictable comment blocks.

## Best targets

public modules, classes, functions, subs, properties, COM-facing members

## Canonical syntax

```text
' Name: Add
' Purpose: Add two integers.
' Parameters: a, b
Public Function Add(ByVal a As Integer, ByVal b As Integer) As Integer
Add = a + b
End Function
```

## Example

```text
' Name: BuildReport
' Purpose: Build the current report snapshot.
' Parameters: request
Public Function BuildReport(ByVal request As Variant) As Variant
...
End Function
```

## External tool access

VBDOX-style generators, legacy code analysis tooling

```text
VBDOX project.vbp
legacy code analysis and documentation tools
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

Preserve the team’s exact header field names when a legacy generator already depends on them. Consistency matters more than stylistic novelty here.
