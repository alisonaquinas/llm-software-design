# Ruby documentation convention

## Preferred convention

YARD comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer YARD because it is the dominant machine-readable Ruby API documentation convention and supports tags, types, and generated reference sites.

## Best targets

public classes, modules, methods, constants, DSL entry points

## Canonical syntax

```text
# Add two integers.
# @param a [Integer] left operand
# @param b [Integer] right operand
# @return [Integer] sum of the operands
def add(a, b)
  a + b
end
```

## Example

```text
# Build the current report snapshot.
# @param request [ReportRequest] immutable report request
# @return [ReportSnapshot] generated snapshot
def build(request)
  ...
end
```


## Core tag set

YARD works best when it documents Ruby's dynamic surface without pretending the code is static.

- `@param` and `@return` for method contracts
- `@option` for hash options and DSL-like call sites
- `@yield` or `@yieldparam` when blocks are part of the API
- `@raise` when callers truly need to handle an error case
- `@example` and `@see` for navigation and usage that survive rendered docs

## External tool access

YARD, IDEs, generated API sites

```text
yard doc
yard server --reload
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

Use explicit tags for parameters and return values when the method contract is not obvious from naming alone.

## Anti-patterns

- documenting only the happy path while ignoring yielded blocks, option hashes, or mutation
- pretending a duck-typed API is stricter or safer than the runtime behavior actually is
- describing internal metaprogramming helpers instead of the public DSL entry points callers see
- copying examples that use old constant names or namespaces
- mixing free-form comments and YARD tags inconsistently across similar modules

## Reference starting points

- [YARD](https://yardoc.org/)
- Ruby project conventions for blocks, option hashes, and public DSL surfaces
- CI or review checks that validate generated API docs and examples
