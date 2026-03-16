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


## Core tag set

Use the smallest truthful GNATdoc tag set that still explains the contract.

- `@summary` for the one-line purpose
- `@description` when a longer narrative actually helps callers
- `@param` for meaningful input or in out arguments
- `@return` for function result meaning
- `@exception` when callers truly need to plan for a raised exception
- place comments on package specs and visible declarations, not only on bodies

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

## Anti-patterns

- documenting package bodies while leaving the package specification thin
- letting `@param` names differ from the declaration spelling or casing
- using GNATdoc tags to describe behavior that the spec does not actually expose
- repeating implementation commentary where a stable contract summary would be clearer
- mixing free-form banner comments with tagged GNATdoc blocks on the same surface without a migration plan

## Reference starting points

- [GNATdoc User's Guide](https://docs.adacore.com/gnatdoc-docs/users_guide/_build/html/gnatdoc.html)
- Ada project guidance for package specifications, contracts, and exception documentation
- house rules for when to document protected and private operations in safety-critical code
