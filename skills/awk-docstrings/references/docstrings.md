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


## Recommended header fields

For Awk, document the data contract as carefully as the function name.

- function or script name
- purpose in one sentence
- expected record shape, field separator assumptions, and required variables
- outputs, printed columns, or changed files
- global arrays or state that the script reads or mutates
- environment assumptions such as `gawk` extensions or required command-line variables

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

## Anti-patterns

- documenting a function name but not the expected input record shape
- hiding global array mutation or output formatting side effects
- scattering partial comments across `BEGIN`, main, and `END` blocks without a clear entry summary
- switching header field names across files so simple parsers cannot stay reliable
- claiming portability while depending on `gawk`-specific behavior without saying so

## Reference starting points

- project conventions for `awk`, `gawk`, or `mawk` compatibility
- any awkdoc-style parser or internal script catalog the repository already uses
- data format specifications for the files the script reads and emits
