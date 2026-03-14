# TypeScript documentation convention

## Preferred convention

TSDoc-style JSDoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code
- prefer comments on exported declarations because that is what API extraction tools and IDEs surface

## Why this is the default

TypeScript ecosystems commonly use JSDoc syntax with TSDoc-compatible tag semantics so tools such as TypeDoc, API Extractor, and IDE language services can parse comments consistently. The goal is not only readable prose, but stable machine-readable API metadata.

## Best targets

- exported functions and classes
- interfaces, type aliases, enums, and namespaces that form part of the public contract
- overloaded signatures where callers need semantic guidance
- generics whose type parameters need explanation
- module entry points and factory functions used outside the declaring file

## Required structure

Start with a one-line summary, then add only the tags that materially improve downstream docs.

Common tags:

- `@param` for parameters
- `@returns` for return semantics
- `@remarks` for longer narrative context
- `@example` for usage examples that should survive into rendered docs
- `@throws` when callers truly need to plan for an exception path
- `@typeParam` for meaningful generic parameters
- `@deprecated` when the symbol remains supported but callers need a migration path
- `@see` or inline `{@link ...}` for related APIs

## Canonical pattern

```text
/**
 * Build the current report snapshot.
 *
 * @param request - Immutable report request.
 * @returns Generated snapshot.
 */
export function build(request: ReportRequest): ReportSnapshot {
  ...
}
```

## Generic example

```text
/**
 * Group items by key.
 *
 * @typeParam TItem - Source item type.
 * @typeParam TKey - Key type returned by the selector.
 * @param items - Items to group.
 * @param getKey - Selector that computes the grouping key.
 * @returns A map from key to grouped items.
 */
export function groupBy<TItem, TKey>(
  items: readonly TItem[],
  getKey: (item: TItem) => TKey,
): Map<TKey, TItem[]> {
  ...
}
```

## External tool access

```text
typedoc src
api-extractor run
tsc --emitDeclarationOnly
```

## Migration guidance

- convert declaration-adjacent comments incrementally so mixed-style files can be cleaned up safely over time
- attach comments to the exported declaration that emits the public type information
- preserve existing tag spellings and ordering when the repository already lints or renders them consistently
- verify rendered docs, declaration emit, and IDE hover help after changes

## Review checklist

- [ ] The chosen convention matches the surrounding toolchain or house style.
- [ ] Comments are attached to the declarations external tools actually inspect.
- [ ] Parameter names, generic names, and return semantics match the signature exactly.
- [ ] Examples compile or are close enough to be validated in tests.
- [ ] `@deprecated`, `@remarks`, and `@throws` are used intentionally rather than by habit.
- [ ] Comments describe the emitted public API, not only source-level implementation trivia.

## Anti-patterns

- documenting internal local helper detail on public interfaces
- repeating obvious type information instead of explaining meaning or constraints
- using tags unsupported by the repository's chosen tooling without checking render output
- leaving overloads or generic parameters undocumented when callers cannot infer intent
- letting examples drift away from actual exported names or behavior

## Reference starting points

- [TSDoc](https://tsdoc.org/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [TypeScript JSDoc Reference](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html)
