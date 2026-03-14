# R documentation convention

## Preferred convention

roxygen2 comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer roxygen2 comments because they are the standard source-adjacent format for R packages and generate both Rd documentation and NAMESPACE updates.

## Best targets

exported functions, S3 or S4 methods, datasets, package-level docs

## Canonical syntax

```text
#' Add two integers
#'
#' @param a Left operand.
#' @param b Right operand.
#' @return Sum of the operands.
add <- function(a, b) {
  a + b
}
```

## Example

```text
#' Build the current report snapshot
#'
#' @param request Immutable report request.
#' @return A report_snapshot object.
#' @export
build_report <- function(request) {
  ...
}
```

## External tool access

roxygen2, pkgdown, IDE help, generated Rd pages

```text
roxygen2::roxygenise()
devtools::document()
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

Keep the roxygen block directly above the object definition. Use package-level docs when the public entry point is the package itself.
