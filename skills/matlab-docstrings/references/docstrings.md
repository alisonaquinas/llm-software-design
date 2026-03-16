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


## Help text shape

MATLAB help text works best when the first lines act like a stable command synopsis.

- Start with a concise H1 line that names the function or script and its purpose.
- Follow with syntax, inputs, outputs, examples, and "See also" material when those sections add real value.
- Keep the help block immediately after the function signature or at the top of the script.
- Document name-value pairs, units, table variables, and side effects when users cannot infer them from the signature alone.
- Treat class methods and package functions the same way users encounter them through `help` and editor tooltips.

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

## Anti-patterns

- burying the H1 line under decorative comments so `help` shows an unhelpful summary
- documenting examples that require hidden workspace state or undocumented paths
- using the help block for implementation notes instead of caller-facing behavior
- leaving name-value options or output shapes implicit when they are central to correct use
- splitting help text away from the function it documents so extraction becomes fragile

## Reference starting points

- MathWorks documentation on function help text and code analyzer guidance
- repository conventions for H1 lines, examples, and published scripts
- CI or review checks that verify help text after signature changes
