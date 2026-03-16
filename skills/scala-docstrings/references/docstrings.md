# Scala documentation convention

## Preferred convention

Scaladoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer Scaladoc comments because they are the standard API documentation mechanism for Scala libraries and support Markdown-rich generated reference sites.

## Best targets

public classes, traits, objects, methods, type params, givens

## Canonical syntax

```text
/**
 * Add two integers.
 * @param a left operand
 * @param b right operand
 * @return sum of the operands
 */
def add(a: Int, b: Int): Int = a + b
```

## Example

```text
/**
 * Build the current report snapshot.
 * @param request immutable report request
 * @return generated snapshot
 */
def build(request: ReportRequest): ReportSnapshot = ???
```


## Core tag set

Scaladoc is at its best when it explains the type-level contract, not just the method name.

- `@param` and `@tparam` for value and type parameters
- `@return` and `@throws` for contract essentials
- `@constructor`, `@note`, and `@example` when they materially improve navigation or usage
- `@see` for related APIs
- document givens, extension methods, and opaque or abstract types when they are part of the public surface

## External tool access

scaladoc, IDE hover help, generated API sites

```text
scaladoc src/main/scala/**/*.scala
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

Document the library boundary that external callers consume. Avoid burying important contracts in private implementation comments.

## Anti-patterns

- explaining only the method name while leaving type parameters or context bounds mysterious
- documenting implementation tricks instead of the stable public algebra or type contract
- skipping extension methods or givens even though they are how callers actually experience the API
- using tags or markup the active Scaladoc version does not render the way you expect
- leaving examples behind after package or import changes

## Reference starting points

- [Scala documentation](https://docs.scala-lang.org/)
- Scaladoc guidance for the Scala version used by the repository
- project conventions for givens, extension methods, and type-level contracts
