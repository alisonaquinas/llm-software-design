# Rust documentation convention

## Preferred convention

rustdoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer native rustdoc comments because they are compiled into standard library-style documentation and support doctests, module docs, and intra-doc links.

## Best targets

public modules, traits, structs, enums, functions, macros

## Canonical syntax

```text
/// Add two integers.
///
/// # Examples
///
/// ```
/// assert_eq!(add(2, 3), 5);
/// ```
pub fn add(a: i32, b: i32) -> i32 {
a + b
}
```

## Example

```text
//! Report generation APIs.

/// Build the current report snapshot.
pub fn build(request: ReportRequest) -> ReportSnapshot {
...
}
```

## External tool access

cargo doc, rustdoc, IDE hover help

```text
cargo doc --no-deps
rustdoc src/lib.rs
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

Use `//!` for module or crate docs and `///` for items. Keep doctests correct because external tools can compile and run them.
