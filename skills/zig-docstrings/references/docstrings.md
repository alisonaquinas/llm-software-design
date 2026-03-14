# Zig documentation convention

## Preferred convention

Zig doc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer native triple-slash doc comments because Zig tooling can emit documentation directly from them and present them in generated reference output.

## Best targets

public declarations, structs, enums, unions, functions, tests where useful

## Canonical syntax

```text
/// Add two integers and return the sum.
pub fn add(a: i32, b: i32) i32 {
return a + b;
}
```

## Example

```text
/// Build the current report snapshot.
pub fn build(request: ReportRequest) ReportSnapshot {
...
}
```

## External tool access

zig build docs, emitted HTML docs, editor help

```text
zig build docs
zig test -femit-docs
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

Write comments on the public declaration that gets emitted into docs. Keep examples correct because they often become part of the generated narrative.
