# C# documentation convention

## Preferred convention

XML documentation comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer triple-slash XML comments because they are native to the compiler, feed IntelliSense, and can be emitted into XML for downstream tools.

## Best targets

public types, members, interfaces, records, generics

## Canonical syntax

```text
/// <summary>Add two integers.</summary>
/// <param name="a">Left operand.</param>
/// <param name="b">Right operand.</param>
/// <returns>Sum of the operands.</returns>
int Add(int a, int b);
```

## Example

```text
/// <summary>Build the current report snapshot.</summary>
/// <param name="request">Immutable report request.</param>
/// <returns>Generated snapshot.</returns>
public ReportSnapshot Build(ReportRequest request) => ...;
```

## External tool access

compiler XML output, IntelliSense, DocFX, Sandcastle-like tooling

```text
dotnet build -p:GenerateDocumentationFile=true
docfx build
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

Keep XML tags structurally valid and ensure parameter names match the signature exactly so external tools do not drop the documentation.
