# PHP documentation convention

## Preferred convention

PHPDoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer PHPDoc because it is the dominant source documentation convention for PHP and is understood by IDEs, analyzers, and documentation generators.

## Best targets

public classes, methods, functions, properties, templates, array shapes

## Canonical syntax

```text
/**
 * Add two integers.
 *
 * @param int $a Left operand.
 * @param int $b Right operand.
 * @return int Sum of the operands.
 */
function add(int $a, int $b): int
{
return $a + $b;
}
```

## Example

```text
/**
 * Build the current report snapshot.
 *
 * @param ReportRequest $request Immutable report request.
 * @return ReportSnapshot Generated snapshot.
 */
function build(ReportRequest $request): ReportSnapshot
{
...
}
```


## Core tag set

PHPDoc is most valuable when it fills gaps native syntax cannot carry by itself.

- `@param`, `@return`, and `@throws` for the core contract
- `@var` and `@property` when runtime-accessible shape matters on objects or arrays
- `@template` and related tags when generics-like contracts matter to Psalm or PHPStan
- `@deprecated` for migration guidance on still-supported APIs
- keep native type hints and PHPDoc synchronized so static analysis and IDEs do not disagree

## External tool access

phpDocumentor, Psalm, PHPStan, IDE hover help

```text
phpDocumentor run
phpstan analyse
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

Keep types synchronized with real signatures. Use PHPDoc to clarify generics, shapes, and exceptions that native syntax cannot express fully.

## Anti-patterns

- using PHPDoc to contradict native parameter or return types
- documenting scalar types in prose but ignoring the real array shape, generic, or exception contract
- copying class-level tags to methods that have materially different behavior
- overusing `@throws` for generic runtime failures callers cannot act on
- leaving stale examples after namespace, type, or template changes

## Reference starting points

- [phpDocumentor](https://docs.phpdoc.org/)
- [PHPStan](https://phpstan.org/)
- [Psalm](https://psalm.dev/)
