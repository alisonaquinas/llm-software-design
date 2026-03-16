# Fortran documentation convention

## Preferred convention

FORD markup comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer modern FORD-compatible comments in source because they are the most common documentation convention for contemporary Fortran codebases that generate API docs.

## Best targets

modules, procedures, derived types, public interfaces

## Canonical syntax

```text
!! Add two integers.
!! @param a Left operand.
!! @param b Right operand.
integer function add(a, b)
  integer, intent(in) :: a, b
  add = a + b
end function add
```

## Example

```text
!> Build the current report snapshot.
module function build_report(request) result(report)
  type(report_request), intent(in) :: request
  type(report_snapshot) :: report
end function build_report
```


## Structural expectations

FORD-friendly comments should stay close to the interface callers see.

- use a consistent comment style such as `!>` or `!!` across a file or module
- document module procedures, public interfaces, and derived types before private helper routines
- keep parameter intent, units, shapes, and allocatable behavior aligned with the real declaration
- prefer comments on interface-visible declarations when generic interfaces or module procedures hide the implementation detail
- use markup and tags only when the active FORD configuration actually renders them usefully

## External tool access

FORD, compatible source documentation generators, IDE readers

```text
ford project.md
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

Place documentation in interface-visible declarations. Keep fixed-form and free-form source differences in mind when editing legacy code.

## Anti-patterns

- mixing fixed-form and free-form comment conventions in ways that break extraction
- documenting only the implementation body when callers consume a generic interface or module procedure
- omitting array shape, units, or intent details that scientific callers actually need
- claiming numerical guarantees or side effects the procedure does not enforce
- using elaborate markup that the repository's FORD pipeline does not render or test

## Reference starting points

- [FORD](https://forddocs.readthedocs.io/)
- compiler and IDE guidance for modern free-form Fortran comments
- project conventions for scientific units, array shapes, and module interface docs
