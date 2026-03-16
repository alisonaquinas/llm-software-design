# ML documentation convention

## Preferred convention

structured comments adjacent to signatures

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer structured comments next to signatures because Standard ML family tooling has no single universal docstring format and readers depend on stable comment placement around exported signatures.

## Best targets

signature files, structures, functors, exported functions, datatypes

## Canonical syntax

```text
(* add : int -> int -> int
   Add two integers and return the sum. *)
fun add a b = a + b
```

## Example

```text
(* build_report : request -> report
   Build the current report snapshot. *)
fun build_report request = ...
```


## Signature-first expectations

Standard ML ecosystems usually document the interface boundary rather than every implementation detail.

- Prefer comments adjacent to signature items and exported declarations.
- Keep the signature text, type variables, and prose aligned so readers can trust the contract.
- Document functors, structures, and datatypes when they are part of the externally consumed surface.
- Explain invariants, mutation, and exceptions when callers must know them.
- When `.sig` files exist, treat them as the primary documentation surface and keep implementation comments secondary.

## External tool access

signature browsers, repository indexing, literate documentation tools

```text
signature files, literate build tooling, internal doc extraction
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

Document the signature boundary first. When `.sig` files exist, treat them as the canonical place for externally consumed documentation.

## Anti-patterns

- documenting an implementation function while leaving the signature item undocumented
- repeating type syntax without explaining invariants or exception behavior
- letting `.sig` and `.sml` comments diverge on the public contract
- over-documenting local helper bindings that external readers never see
- mixing comment schemas within one component so simple extractors cannot stay predictable

## Reference starting points

- project guidance for `.sig` versus implementation-file documentation
- build or literate tooling used to publish ML API notes in the repository
- code review checklists for exception behavior, mutation, and abstract type invariants
