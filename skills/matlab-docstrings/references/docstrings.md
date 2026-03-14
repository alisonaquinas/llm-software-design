# MATLAB documentation convention

## Preferred convention

leading help text comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer MATLAB help text at the top of functions, classes, and scripts because the environment exposes it directly through `help`, `doc`, and published output.

## Best targets

functions, classdefs, scripts, packages, examples

## Canonical syntax

```text
function total = add(a, b)
%ADD Add two integers.
%   TOTAL = ADD(A, B) returns the sum of A and B.

total = a + b;
end
```

## Example

```text
function report = buildReport(request)
%BUILDREPORT Build the current report snapshot.
%   REPORT = BUILDREPORT(REQUEST) returns a report struct.

...
end
```

## External tool access

help, doc, publish, toolbox reference generation

```text
help add
doc add
publish(script.m)
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

Make the first help line a compact signature-style summary. Keep usage examples close to the public entry point.
