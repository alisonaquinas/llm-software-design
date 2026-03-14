# Lisp documentation convention

## Preferred convention

Common Lisp docstring literals

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer native docstring string literals on definitions because Common Lisp stores them with many definition forms and exposes them programmatically.

## Best targets

functions, variables, classes, generic functions, methods, packages

## Canonical syntax

```text
(defun add (a b)
  "Add two integers and return the sum."
  (+ a b))
```

## Example

```text
(defclass report-builder () ()
  (:documentation "Build report snapshots from immutable requests."))
```

## External tool access

documentation function, SLIME or SLY help, DECLT-style generators

```text
(documentation 'add 'function)
DECLT or implementation-specific doc extractors
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

Document the public operator and package surface first. Keep the docstring synchronized with argument semantics and side effects.
