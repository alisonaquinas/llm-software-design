# Awk documentation convention

## Preferred convention

structured script and function header comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer disciplined header comments because Awk provides ordinary comments only and external tooling generally depends on structured script or function summaries.

## Best targets

scripts, reusable functions, BEGIN or END entry points, expected input formats

## Canonical syntax

```text
# add: add two integers and print the sum
function add(a, b) {
return a + b
}
```

## Example

```text
# build_report: build the current report snapshot from input rows
function build_report(request) {
...
}
```

## External tool access

repository search, lightweight parsers, generated script docs

```text
repository indexing, awkdoc-style parsers, generated manpages
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

Document input record shape, required variables, and output side effects. Those details matter more than boilerplate prose in most Awk programs.
