# OCaml documentation convention

## Preferred convention

odoc-compatible comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer odoc-compatible comments because they are the standard API documentation convention in modern OCaml toolchains.

## Best targets

modules, signatures, values, types, classes, functors

## Canonical syntax

```text
(** Add two integers and return the sum. *)
let add a b = a + b
```

## Example

```text
(** Build the current report snapshot. *)
let build request = ...
```

## External tool access

odoc, generated HTML docs, IDE navigation

```text
dune build @doc
odoc html-generate
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

Document `.mli` signatures when they exist. Treat implementation comments as secondary to the externally consumed interface.
