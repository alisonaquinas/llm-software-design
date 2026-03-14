# Assembly Language documentation convention

## Preferred convention

structured leading comments on labels and macros

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer disciplined structured comment headers because assembly has no universal docstring syntax and external tools usually rely on label-adjacent comments or filtered source.

## Best targets

exported labels, macros, calling conventions, register contracts

## Canonical syntax

```text
; add: add two integers in r0 and r1, return in r0
add:
ADD r0, r0, r1
BX  lr
```

## Example

```text
; build_report
; inputs: r0=request pointer
; outputs: r0=report pointer
; clobbers: r1-r3
build_report:
...
```

## External tool access

Doxygen filters, symbol browsers, code review tooling

```text
doxygen with an assembly filter
assembler listing and symbol export tools
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

Always document inputs, outputs, clobbers, calling convention, and side effects. That information is often more useful than prose summaries alone.
