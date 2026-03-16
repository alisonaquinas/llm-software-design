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


## Core tag set

Use a compact XML block that downstream .NET tools can trust.

- `<summary>` for the one-line contract
- `<param>` for each meaningful parameter name
- `<returns>` for result meaning
- `<value>` for properties when the meaning is not obvious
- `<remarks>` or `<example>` only when they add real value to IntelliSense or generated docs
- `<exception>` when callers truly need to handle a declared failure path

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

## Anti-patterns

- malformed XML or misspelled parameter names that silently drop metadata from IntelliSense
- documenting implementation trivia instead of the public contract visible to callers
- copying summaries across overloads or overrides without checking behavior differences
- mixing XML doc comments with unrelated legacy header schemes in the same file without a migration plan
- leaving generated XML output disabled while assuming downstream tools will still see the docs

## Reference starting points

- [Generate XML API documentation comments](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/xmldoc/)
- [Recommended XML documentation tags](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/xmldoc/recommended-tags)
- repository build settings for XML documentation file generation and IntelliSense validation
