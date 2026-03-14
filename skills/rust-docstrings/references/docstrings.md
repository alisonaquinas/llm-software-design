# Rust documentation convention

## Preferred convention

rustdoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code
- prefer doctestable examples when the public API is intended for reuse by other developers

## Why this is the default

Rust has a native documentation system. `///` and `//!` comments are consumed by `rustdoc`, rendered into API docs, indexed for IDE help, and can be compiled and run as documentation tests. That makes rustdoc comments the canonical machine-readable API documentation convention for Rust.

## Best targets

- public crates and modules
- public structs, enums, traits, type aliases, and macros
- public functions and methods
- `unsafe` APIs that require explicit safety contracts
- errors, builders, and extension traits that callers rely on directly

## Outer and inner docs

- Use `//!` for crate-level or module-level documentation.
- Use `///` for items such as functions, structs, enums, traits, and methods.
- Keep crate and module docs focused on purpose, layout, feature flags, and major usage patterns.

## Recommended sections

Add sections only when they help callers. Common high-value sections include:

- `# Examples`
- `# Errors`
- `# Panics`
- `# Safety` for any `unsafe fn` or APIs with caller obligations
- `# Implementation notes` only when downstream maintainers truly need it

## Canonical pattern

```text
/// Build the current report snapshot.
///
/// # Errors
///
/// Returns an error if the request is internally inconsistent.
///
/// # Examples
///
/// ```
/// let snapshot = build(request)?;
/// # Ok::<(), BuildError>(())
/// ```
pub fn build(request: ReportRequest) -> Result<ReportSnapshot, BuildError> {
    ...
}
```

## Module example

```text
//! Report generation APIs.
//!
//! This module contains the public entry points for building report snapshots.
```

## Tooling notes

- Prefer examples that compile and run under doctest when practical.
- Use intra-doc links when they improve navigation and remain stable.
- Hidden setup lines beginning with `#` can keep doctests readable while still compiling.
- Keep `# Safety` sections specific: explain exactly what the caller must uphold.

## External tool access

```text
cargo doc --no-deps
cargo test --doc
rustdoc src/lib.rs
```

## Migration guidance

- convert detached prose comments into `///` or `//!` docs on the items rustdoc actually renders
- document the public crate surface first, especially items re-exported at the crate root
- turn examples into doctests where possible so they stay current
- enable rustdoc lints or `missing_docs` where the repository wants stronger guarantees

## Review checklist

- [ ] Crate and module docs use `//!`, and item docs use `///`.
- [ ] Examples compile, or are intentionally marked for alternative rustdoc behavior.
- [ ] `# Errors`, `# Panics`, and `# Safety` sections are present when the API needs them.
- [ ] Intra-doc links resolve correctly.
- [ ] The docs describe observable behavior and caller obligations, not stale implementation trivia.

## Anti-patterns

- examples that cannot compile or only work because important setup is omitted
- `unsafe` APIs without a concrete `# Safety` section
- claiming panic-free behavior when the implementation can still panic on ordinary inputs
- documenting every private helper while leaving re-exported public APIs thin or undocumented
- prose that duplicates the type signature but fails to explain usage intent

## Reference starting points

- [What is rustdoc?](https://doc.rust-lang.org/rustdoc/what-is-rustdoc.html)
- [Documentation tests](https://doc.rust-lang.org/rustdoc/write-documentation/documentation-tests.html)
- [Rustdoc lints](https://doc.rust-lang.org/rustdoc/lints.html)
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
