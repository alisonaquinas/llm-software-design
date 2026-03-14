# Erlang documentation convention

## Preferred convention

EDoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer EDoc comments because they are the standard machine-readable documentation format for Erlang modules and functions.

## Best targets

modules, exported functions, callbacks, records, types

## Canonical syntax

```text
%% @doc Add two integers.
%% @spec add(integer(), integer()) -> integer().
add(A, B) ->
A + B.
```

## Example

```text
%% @doc Build the current report snapshot.
%% @spec build(report_request()) -> report_snapshot().
build(Request) ->
...
```

## External tool access

EDoc, generated HTML docs, IDE help

```text
edoc:application(my_app, ".", []).
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

Document exported functions first and keep specs synchronized with code so generated docs and analysis stay aligned.
