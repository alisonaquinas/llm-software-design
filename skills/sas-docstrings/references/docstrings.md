# SAS documentation convention

## Preferred convention

structured header comments above macros and steps

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer disciplined header comments because SAS has no universal native docstring system and external tooling commonly depends on predictable block comments above macros or data steps.

## Best targets

macros, major data steps, PROC wrappers, shared include files

## Canonical syntax

```text
/*
Purpose: Add two values and store the total.
Inputs: A, B
Outputs: TOTAL
*/
%macro add(a, b);
  %let total = %eval(&a + &b);
%mend;
```

## Example

```text
/*
Purpose: Build the current report snapshot.
Inputs: source tables
Outputs: WORK.REPORT
*/
%macro build_report();
  ...
%mend;
```


## Recommended header fields

SAS comments are much more useful when they expose data flow, dependencies, and side effects.

- macro or step name
- purpose in one sentence
- input datasets, libraries, macro variables, and required options
- outputs, created datasets, reports, or files
- side effects such as WORK table creation, option changes, or log behavior
- external dependencies including formats, autocall macros, or scheduling assumptions

## External tool access

repository search, internal code scanners, generated listings

```text
code scanners, repository indexing, generated listings
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

Record inputs, outputs, dependencies, and side effects explicitly. Those fields make free-form SAS comments much more useful to external tooling.

## Anti-patterns

- documenting only the macro name and skipping required datasets, libraries, or variables
- hiding option changes or WORK-table side effects in unstructured prose
- scattering partial comments across macros and data steps without a clear entry summary
- using different field labels in similar jobs so parsers and reviewers lose consistency
- letting report names or dataset outputs drift after refactors

## Reference starting points

- internal batch or ETL standards for macro headers and data-step comments
- scheduler, autocall, and dataset contract documentation used by the team
- code review checklists for library dependencies, outputs, and side effects
