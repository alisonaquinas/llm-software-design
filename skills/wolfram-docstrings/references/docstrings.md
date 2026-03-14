# Wolfram documentation convention

## Preferred convention

usage messages on public symbols

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer usage messages on public symbols because they are the primary source-adjacent documentation surface exposed by the Wolfram Language help system.

## Best targets

public symbols, package exports, options, message groups

## Canonical syntax

```text
AddTotal::usage = "AddTotal[a, b] returns the sum of a and b.";
```

## Example

```text
BuildReport::usage = "BuildReport[request] returns the current report snapshot.";
```

## External tool access

question-mark help queries, notebook help integration, paclet documentation workflows

```text
?AddTotal
DocumentationTools or paclet workflows when the codebase uses them
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

Keep the usage string concise and signature-shaped. Add richer notebook or paclet docs only when the project already invests in that packaging layer.
