# Prolog documentation convention

## Preferred convention

PlDoc structured comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer PlDoc comments because they are the standard structured source documentation format in modern SWI-Prolog workflows and can be extracted automatically.

## Best targets

exported predicates, modules, multifile hooks, major facts

## Canonical syntax

```text
%! add(+A, +B, -Sum) is det.
%  Sum is the sum of A and B.
add(A, B, Sum) :-
Sum is A + B.
```

## Example

```text
%% build_report(+Request, -Report) is det.
%% Build the current report snapshot.
build_report(Request, Report) :-
...
```

## External tool access

PlDoc, generated HTML and LaTeX, in-process doc server

```text
swipl -g doc_server -t halt
swipl -g doc_save -t halt
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

Keep mode indicators and determinism accurate. External tools rely on that structure as much as the prose summary.
