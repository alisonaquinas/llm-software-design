# Lua documentation convention

## Preferred convention

LDoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer LDoc-compatible comments because they are a widely recognized source documentation convention for Lua modules and can be generated without altering runtime semantics.

## Best targets

modules, exported functions, tables, metatables, class-like patterns

## Canonical syntax

```text
--- Add two integers.
-- @param a left operand
-- @param b right operand
-- @return sum of the operands
local function add(a, b)
  return a + b
end
```

## Example

```text
--- Build the current report snapshot.
-- @param request immutable report request
-- @return report snapshot
function report.build(request)
  ...
end
```


## Core tag set

LDoc is most helpful when comments expose module shape, not just function prose.

- `@param` and `@return` for function contracts
- `@field` for documented tables and class-like modules
- `@tparam` when the codebase uses typed parameter annotations
- `@usage` for short examples worth surfacing in rendered docs
- keep module-level blocks close to the table or export surface that downstream tools index

## External tool access

LDoc, IDE helpers, repository documentation sites

```text
ldoc .
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

Keep module-level comments near the table or module declaration so generated docs preserve the intended grouping.

## Anti-patterns

- documenting a method without explaining the module table or object shape it belongs to
- using LDoc tags inconsistently across similar modules so generated sections become uneven
- describing implicit globals or mutation only in implementation comments
- attaching comments to local helpers instead of the exported table members callers see
- drifting examples after renaming the module or receiver form

## Reference starting points

- [LDoc](https://lunarmodules.github.io/ldoc/)
- Lua module and package conventions already used by the repository
- any editor or CI checks that validate generated module docs
