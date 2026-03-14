# Visual Basic documentation convention

## Preferred convention

XML documentation comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer triple-apostrophe XML comments because the compiler can emit machine-readable XML that IDEs and documentation tools consume directly.

## Best targets

public modules, classes, interfaces, methods, properties, events

## Canonical syntax

```text
''' <summary>Add two integers.</summary>
''' <param name="a">Left operand.</param>
''' <param name="b">Right operand.</param>
''' <returns>Sum of the operands.</returns>
Function Add(a As Integer, b As Integer) As Integer
```

## Example

```text
''' <summary>Build the current report snapshot.</summary>
''' <param name="request">Immutable report request.</param>
''' <returns>Generated snapshot.</returns>
Public Function Build(request As ReportRequest) As ReportSnapshot
```

## External tool access

compiler XML output, IntelliSense, .NET doc generators

```text
dotnet build -p:GenerateDocumentationFile=true
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

Keep the comment block immediately above the symbol. Correct XML tag names and exact parameter names are important for downstream tooling.
