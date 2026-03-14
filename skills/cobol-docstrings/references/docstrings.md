# COBOL documentation convention

## Preferred convention

structured program and paragraph comment headers

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer disciplined structured headers because COBOL has no universal docstring syntax and most downstream tooling relies on repeatable comment templates rather than free-form prose.

## Best targets

programs, copybooks, sections, paragraphs, file layouts, data items

## Canonical syntax

```text
*> NAME: ADD-TOTAL
*> PURPOSE: Add two amounts and return the total.
*> INPUTS: A, B
ADD-TOTAL SECTION.
ADD A TO B GIVING TOTAL.
```

## Example

```text
*> NAME: BUILD-REPORT
*> PURPOSE: Build the current report snapshot.
*> INPUTS: REQUEST-REC
BUILD-REPORT SECTION.
...
```

## External tool access

enterprise analyzers, repository scanners, generated listings

```text
enterprise analysis tooling
source scanners that parse fixed-format comment headers
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

Document data layout, side effects, file usage, and batch dependencies explicitly. Those details are often the most valuable external documentation in COBOL estates.
