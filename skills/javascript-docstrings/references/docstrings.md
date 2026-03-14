# JavaScript documentation convention

## Preferred convention

JSDoc comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code
- add type expressions only when they help the chosen toolchain or reviewer

## Why this is the default

JSDoc is the dominant JavaScript source-adjacent documentation convention. It feeds classic JSDoc site generation, IDE hover help, and TypeScript-powered editor tooling. In JavaScript projects that use `// @ts-check`, JSDoc often becomes both human documentation and machine-readable type metadata.

## Best targets

- exported functions, classes, factories, and custom elements
- `@typedef` and `@callback` definitions that describe shared object shapes
- module entry points and configuration objects consumed from other files
- events, hooks, and extension points that callers must implement correctly

## Core tag set

Use only the tags that materially help callers or tools.

- `@param`
- `@returns`
- `@typedef`
- `@callback`
- `@template` when generics are useful to the toolchain
- `@throws` for real exception contracts
- `@deprecated`, `@see`, and `{@link ...}` for migration and discovery

## Canonical syntax

```text
/**
 * Add two integers.
 * @param {number} a - Left operand.
 * @param {number} b - Right operand.
 * @returns {number} Sum of the operands.
 */
export function add(a, b) {
  return a + b;
}
```

## Shared shape example

```text
/**
 * @typedef {object} ReportRequest
 * @property {string} id - Stable report identifier.
 * @property {boolean} includeTotals - Whether totals should be calculated.
 */

/**
 * Build the current report snapshot.
 * @param {ReportRequest} request - Immutable report request.
 * @returns {Promise<ReportSnapshot>} Generated snapshot.
 */
export async function build(request) {
  ...
}
```

## Tooling notes

- In plain JavaScript files, JSDoc can carry both documentation and useful type information.
- TypeScript tooling supports many JSDoc tags in `.js` files and can use them for editor feedback and `.d.ts` generation.
- Keep the comment immediately above the declaration the tool should inspect.

## External tool access

```text
jsdoc src -r
tsc --allowJs --checkJs
tsc --allowJs --declaration --emitDeclarationOnly
```

## Migration guidance

- convert detached block comments into declaration-adjacent JSDoc blocks
- document exported surfaces first, then shared typedefs that make downstream usage clearer
- preserve a repository's tag spelling and ordering when lint or rendering already depends on it
- verify generated docs, editor hover help, and any emitted declaration files after changes

## Review checklist

- [ ] The chosen convention matches the surrounding toolchain or house style.
- [ ] Parameter names and object-shape properties match the real code.
- [ ] Type expressions are accurate and not copied from stale assumptions.
- [ ] Examples and promises reflect real async behavior.
- [ ] `@typedef` and `@callback` are used where they improve reuse and discoverability.

## Anti-patterns

- documenting internal locals instead of exported entry points
- using JSDoc to assert types the runtime never validates at any boundary
- duplicating obvious syntax while failing to explain meaning, units, ownership, or side effects
- leaving stale typedef property names after refactors
- mixing multiple incompatible comment dialects in one file without a migration plan

## Reference starting points

- [JSDoc Getting Started](https://jsdoc.app/about-getting-started)
- [JSDoc block and inline tags](https://jsdoc.app/about-block-inline-tags)
- [TypeScript JSDoc Reference](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html)
