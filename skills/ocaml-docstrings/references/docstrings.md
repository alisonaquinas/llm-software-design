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


## Interface-first expectations

`odoc` works best when comments follow the interface that users consume.

- Prefer comments on `.mli` signatures and public module interfaces when they exist.
- Use `(** ... *)` comments attached to the next significant item that `odoc` will render.
- Keep module, type, value, and functor docs aligned with the exported surface instead of the implementation detail hidden behind it.
- Use `.mld` pages for package-level narrative only when the repository already publishes those docs.
- Check hidden or internal modules so comments do not accidentally promise APIs that the package does not expose.

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

## Anti-patterns

- documenting `.ml` implementation details while leaving the `.mli` contract sparse
- attaching a comment where `odoc` associates it with the wrong item
- leaving functor arguments, abstract types, or canonical module paths unexplained when they are central to use
- mixing package-level prose and API comments in a way that duplicates or contradicts the rendered docs
- forgetting to re-check generated docs after hiding or re-exporting modules

## Reference starting points

- [Generating Documentation With odoc](https://ocaml.org/docs/generating-documentation)
- [odoc package](https://ocaml.org/p/odoc/3.1.0/features.html)
- Dune or opam configuration that controls the public documentation surface
