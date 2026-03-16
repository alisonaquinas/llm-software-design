# Haskell documentation convention

## Preferred convention

Haddock comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer Haddock comments because they are the standard Haskell API documentation format and support module docs, inline markup, and generated reference sites.

## Best targets

modules, exported functions, types, classes, instances, operators

## Canonical syntax

```text
-- | Add two integers and return the sum.
add :: Int -> Int -> Int
add a b = a + b
```

## Example

```text
-- | Build the current report snapshot.
build :: ReportRequest -> ReportSnapshot
build request = ...
```


## Structural expectations

Haddock supports more than one placement pattern, and placement matters.

- Use `-- |` before a declaration for the main comment on a function, type, or module item.
- Use `-- ^` only for trailing documentation of the preceding item when that shape is clearer.
- Keep module export lists and comments aligned so generated docs reflect the intended public surface.
- Document type classes, instances, operators, and records only when the surrounding package surface actually exposes them.
- Prefer one clear summary plus a truthful note on laws, partiality, or effects over long filler text.

## External tool access

Haddock, Hackage-style docs, IDE support

```text
cabal haddock
stack haddock
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

Keep module export lists and comments aligned so generated documentation reflects the intended public surface.

## Anti-patterns

- putting comments in a place Haddock associates with the wrong symbol
- documenting partial or effectful behavior as if it were total and harmless
- leaving operator semantics implicit when the name alone is not enough
- drifting export lists and docs so generated pages imply the wrong public surface
- mixing literate Haskell and comment conventions without checking the rendered result

## Reference starting points

- Haddock documentation and the package's Cabal or Stack doc build configuration
- Hackage rendering of similar public APIs in the same ecosystem
- project conventions for laws, partial functions, and effect descriptions
