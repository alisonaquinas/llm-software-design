# VBScript documentation convention

## Preferred convention

structured header comments for script analyzers

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer stable structured comment headers because VBScript has no native machine-readable docstring feature and most extractors depend on comment templates.

## Best targets

public script functions, classes, entry scripts, COM automation helpers

## Canonical syntax

```text
' Name: AddTotal
' Purpose: Add two amounts and return the total.
Function AddTotal(a, b)
AddTotal = a + b
End Function
```

## Example

```text
' Name: BuildReport
' Purpose: Build the current report snapshot.
Function BuildReport(request)
...
End Function
```


## Recommended header fields

VBScript extractors are usually simple, so stable field names matter.

- Name
- Purpose
- Inputs or Parameters
- Returns when the function computes a result
- Side effects such as file writes, COM automation, or environment use
- Dependencies or assumptions such as required host, objects, or global variables

## External tool access

VBDOX-like tooling, repository scanners, code review indexing

```text
legacy documentation generators and repository scanners
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

Use a predictable header vocabulary such as Name, Purpose, Inputs, and Returns so simple extractors can remain reliable.

## Anti-patterns

- documenting only the script name while hiding COM or file-system side effects
- changing field labels between scripts so simple scanners become brittle
- placing a header above the wrong function in long administrative scripts
- omitting host assumptions such as WSH, cscript, or external object availability
- copying a template header without updating parameter or return details

## Reference starting points

- legacy script catalog or repository index conventions already used by the team
- host-environment documentation for WSH, COM automation, and scheduled execution
- code review standards for administrative scripts, file writes, and external dependencies
