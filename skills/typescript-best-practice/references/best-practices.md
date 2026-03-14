# TypeScript best practices

## Scope

- Start by confirming the TypeScript version, module system, build chain, and runtime before giving specific guidance.
- Distinguish published libraries, internal packages, browser apps, Node services, and build scripts because their constraints differ.
- Prefer project-local conventions when they are already automated and internally consistent.
- Use the defaults below when the repository has no clear standard.

## Version and environment gates

Confirm these first because they change the right answer:

- **Runtime target**: browser, Node, Bun, Deno, edge worker, React Native, or mixed isomorphic code.
- **Module system**: ESM, CommonJS, dual-publish package, or bundler-controlled output.
- **Artifact type**: application code, library code, generated code, declaration-only package, or tooling scripts.
- **Strictness level**: whether `strict` and related compiler options are already part of the build contract.

## Review priorities

- identify correctness and behavior-preservation constraints before recommending stylistic cleanup
- prefer conventions that make ownership, dependencies, and change seams easier to understand
- keep project-local standards when they are already automated and internally consistent
- distinguish language defaults from framework, vendor, or deployment-specific rules
- treat declaration files, emitted JavaScript, and runtime validation as part of the design

## Default design choices

### Treat types as contracts

- Prefer explicit domain models, discriminated unions, and narrow interfaces over `any` and assertion-heavy code.
- Use `unknown` at unsafe boundaries and narrow it deliberately.
- Prefer overloads, unions, or dedicated types when they make the caller contract clearer than optional flag combinations.
- Use generics when they express a reusable relationship, not as a way to obscure the concrete shape.

### Keep compile-time and runtime honest

- Validate data at network, storage, environment, and user-input boundaries.
- Do not let static types pretend untrusted JSON is already safe.
- Keep parsing and refinement close to the boundary so downstream code can rely on real invariants.

### Module and package design

- Prefer explicit exports and small focused modules.
- Avoid giant `index.ts` barrels that hide cycles or flatten unrelated concerns.
- Separate runtime code from type-only utilities when that improves clarity.
- Be deliberate about public entry points because they become part of declaration emit and package compatibility.

### Error handling and async behavior

- Model expected failure with clear return contracts or exceptions that the calling layer can handle consistently.
- Prefer `async` and `await` over deeply nested promise chains when it improves flow readability.
- Make cancellation, timeout, and retry behavior explicit at API boundaries.
- Avoid silent promise rejection handling.

## Tooling baseline

| Concern | Preferred baseline |
| --- | --- |
| compiler | run `tsc` in CI, often with `--noEmit` for applications and declaration emit checks for libraries |
| strictness | default to `strict`; enable additional options only when they materially improve safety for the codebase |
| linting | keep one ESLint profile and one formatting path for the whole repo |
| API surface | verify declaration output and exported names for libraries |
| tests | cover runtime behavior that the type system cannot prove |

## Common red flags

- `any`, `as`, or non-null assertions used to suppress design problems rather than model reality
- exported APIs that depend on ambient globals or framework-only assumptions without saying so
- runtime parsing scattered everywhere instead of being centralized at the edge
- enums, unions, or object maps that drift out of sync with one another
- barrels and path aliases that hide cycles and make dependency direction unclear
- generated types or handwritten declarations that no longer match runtime output

## Review checklist

- [ ] The runtime, module system, and compilation target are identified before advice becomes specific.
- [ ] Public types express the real contract rather than papering over unknown input.
- [ ] Narrowing, refinements, and validation happen at the correct boundaries.
- [ ] Exported modules have clear ownership and minimal side effects.
- [ ] Async code propagates errors, cancellation, and cleanup intentionally.
- [ ] `tsc`, linting, formatting, and tests are easy to run in CI.

## Migration playbook

- enable and enforce one compiler path before attempting broad style cleanup
- strengthen public types and edge validation before polishing internal implementation detail
- replace `any` and assertion-heavy seams with small parse-and-refine helpers
- untangle cyclic imports and oversized barrels before reorganizing naming trivia
- add tests around behavior that must remain stable, then refactor toward stricter types

## Reference starting points

- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [TSDoc](https://tsdoc.org/)
- [JSDoc Reference in TypeScript](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html)
- [Creating `.d.ts` from `.js`](https://www.typescriptlang.org/docs/handbook/declaration-files/dts-from-js.html)
