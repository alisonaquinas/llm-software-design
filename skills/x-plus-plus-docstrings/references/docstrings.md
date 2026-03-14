# X++ documentation convention

## Preferred convention

structured line comments above classes and methods

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer disciplined line-comment headers because X++ commonly uses ordinary comments for source documentation and lacks a broadly adopted compiler-emitted docstring system.

## Best targets

public classes, methods, service entry points, table methods

## Canonical syntax

```text
// Add two integers.
// Parameters: a, b
public int add(int a, int b)
{
return a + b;
}
```

## Example

```text
// Build the current report snapshot.
// Parameter: request
public ReportSnapshot build(ReportRequest request)
{
...
}
```

## External tool access

model export, repository indexing, IDE navigation

```text
repository search, model export, internal documentation extraction
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

Keep comment templates short and consistent. Put integration effects, table access, and transaction expectations in the header when external reviewers need that context.
