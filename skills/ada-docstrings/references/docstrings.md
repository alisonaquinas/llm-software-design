# Ada documentation convention

## Preferred convention

GNATdoc comment annotations

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer GNATdoc-compatible comments because they are the most common machine-readable source documentation convention in modern Ada toolchains.

## Best targets

package specs, public subprograms, tagged types, generic units

## Canonical syntax

```text
--  @summary Add two integers.
--  @param A Left operand.
--  @param B Right operand.
function Add (A, B : Integer) return Integer;
```

## Example

```text
--  @summary Build the current report snapshot.
--  @param Request Immutable report request.
function Build (Request : Report_Request) return Report_Snapshot;
```

## External tool access

GNATdoc, IDE help, generated reference sites

```text
gnatdoc -P project.gpr
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

Document the specification package, not the body, whenever the declaration is what external callers consume.
