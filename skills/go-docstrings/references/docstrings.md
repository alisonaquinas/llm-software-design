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


## Structural expectations

Go doc comments have strong conventions beyond just "put a comment here".

- Every exported name should have a doc comment that begins with the identifier it documents.
- Package comments should explain the package as a whole and usually live in a single source file.
- Use Go's lightweight doc syntax for links, lists, headings, and examples instead of ad hoc Markdown features.
- Prefer comments on exported declarations, fields, and interfaces that appear in the public contract.
- When examples matter, keep them aligned with runnable `Example...` tests where possible.

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

## Anti-patterns

- comments that do not begin with the exported identifier name
- documenting unexported helpers more carefully than the package-level public surface
- scattering multiple package comments across files without intending them to concatenate
- using raw Markdown or HTML features that the Go doc formatter does not preserve well
- letting examples, links, or field comments drift after renames

## Reference starting points

- [Go Doc Comments](https://go.dev/doc/comment)
- [go/doc/comment package](https://pkg.go.dev/go/doc/comment)
- `go doc` and `pkgsite` usage within the current module or workspace
