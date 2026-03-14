# Go documentation convention

## Preferred convention

Go doc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer native Go doc comments because they are the standard API documentation format and are consumed by `go doc`, pkgsite, and editor tooling.

## Best targets

packages, exported identifiers, types, functions, methods, constants

## Canonical syntax

```text
package mathx

// Add returns the sum of a and b.
func Add(a, b int) int {
return a + b
}
```

## Example

```text
package report

// Builder creates report snapshots from immutable requests.
type Builder struct{}

// Build returns the current report snapshot.
func (Builder) Build(request Request) Snapshot {
...
}
```

## External tool access

go doc, pkgsite, godoc-compatible tooling, IDE help

```text
go doc ./...
pkgsite -open .
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

Start the comment with the identifier name so generated documentation reads naturally in package indexes.
