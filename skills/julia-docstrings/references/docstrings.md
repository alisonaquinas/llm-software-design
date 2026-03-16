# Julia documentation convention

## Preferred convention

native Julia docstrings

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer native docstrings because Julia attaches them directly to bindings and exposes them immediately through help mode and documentation generators.

## Best targets

functions, macros, types, modules, constants

## Canonical syntax

```text
"""
Add two integers and return the sum.
"""
add(a::Int, b::Int) = a + b
```

## Example

```text
"""
Build the current report snapshot from an immutable request.
"""
function build(request::ReportRequest)
...
end
```


## Structural expectations

Julia docstrings are attached to bindings, so placement is the main contract.

- Put the docstring immediately before the function, type, macro, module, or constant it documents.
- Prefer a concise summary first, then argument semantics, return behavior, and examples when they add value.
- Document multiple dispatch behavior only to the extent callers truly need it; avoid prose that fights the type signatures.
- Use examples when dispatch, mutability, or allocation expectations are not obvious from the signature alone.
- Keep docstrings aligned with exported names and the package surface visible through help mode and Documenter builds.

## External tool access

REPL help mode, Documenter.jl, IDE help

```text
?add
Documenter.jl build
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

Put the docstring immediately before the object it documents. Include examples only when they illuminate dispatch or type expectations.

## Anti-patterns

- inserting blank lines or unrelated code between the docstring and the binding it should attach to
- documenting one method as if it described every dispatch variant in the generic function
- hiding mutating behavior or bang-convention expectations from callers
- over-explaining obvious type syntax while skipping the actual semantic constraints
- letting doctest-style examples drift away from the current API

## Reference starting points

- [Julia documentation manual](https://docs.julialang.org/en/v1/manual/documentation/)
- [Documenter.jl](https://documenter.juliadocs.org/)
- package help-mode and doctest conventions already used in the repository
