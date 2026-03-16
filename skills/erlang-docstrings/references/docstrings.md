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


## Core tag set

Prefer EDoc for prose and native `-spec` or `-type` declarations for type contracts.

- `@doc` for the summary and main narrative
- `@see`, `@since`, and `@author` only when they add real navigational value
- keep comments between declarations so EDoc can associate them with the nearest significant form
- prefer `-spec` and `-type` declarations over older EDoc-only type tags when both are available
- document exported functions, callbacks, records, and types before internal helpers

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

## Anti-patterns

- placing tagged comments on the same line as code or away from the declaration EDoc will attach to
- relying on old `@spec` or `@type` tags while the real source contract moved to `-spec` or `-type`
- documenting internal message formats more carefully than exported functions and callbacks
- leaving determinism, side effects, or process interactions implicit when callers must know them
- mixing free-form prose and tagged comments in ways that confuse the extractor

## Reference starting points

- [EDoc User's Guide](https://www.erlang.org/docs/20/apps/edoc/chapter)
- [EDoc release notes](https://www.erlang.org/doc/apps/edoc/notes.html)
- OTP codebase conventions for `-spec`, `-type`, and exported API docs
