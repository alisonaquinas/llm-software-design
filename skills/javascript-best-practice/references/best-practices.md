# JavaScript best practices

## Scope

- Start by confirming the JavaScript runtime, module system, and deployment target before giving specific guidance.
- Distinguish browser code, Node services, CLIs, build scripts, and cross-runtime packages because their constraints differ.
- Prefer project-local conventions when they are already automated and internally consistent.
- Use the defaults below when the repository has no clear standard.

## Runtime and environment gates

Confirm these first because they materially change the advice:

- **Runtime**: browser, Node, Deno, Bun, edge worker, Electron, or hybrid environment.
- **Module model**: ESM, CommonJS, bundler-managed modules, or legacy script tags.
- **Artifact type**: reusable package, app code, test utilities, or one-off automation.
- **Type strategy**: plain JavaScript only, JSDoc plus `// @ts-check`, or mixed TypeScript interoperability.

## Review priorities

- identify correctness and behavior-preservation constraints before recommending stylistic cleanup
- prefer conventions that make ownership, dependencies, and change seams easier to understand
- keep project-local standards when they are already automated and internally consistent
- distinguish language defaults from framework, vendor, or deployment-specific rules
- treat module boundaries, side effects, and runtime validation as first-class review topics

## Default design choices

### Modules and scope

- Prefer ES modules and explicit imports and exports for new code where the runtime supports them.
- Use `const` by default and `let` when reassignment is intentional.
- Avoid implicit globals and ambient state.
- Keep module initialization side effects minimal and obvious.

### Data boundaries and validation

- JavaScript's flexibility makes boundary validation essential.
- Parse and validate environment variables, request bodies, storage payloads, and user input near the edge.
- Prefer small refinement helpers and clear object-shape documentation over ad hoc property access everywhere.
- Use `Object.freeze`, factory functions, or disciplined mutation boundaries when shared state is unavoidable.

### Async behavior

- Prefer `async` and `await` when it improves readability over raw promise chains.
- Make retries, timeouts, cancellation, and cleanup explicit instead of burying them in utility helpers.
- Never silently swallow promise rejections.
- Keep concurrency limits visible when processing many I/O-bound tasks.

### Error handling

- Throw or propagate errors with enough context for the boundary layer to log or classify them.
- Avoid broad catch-and-ignore patterns.
- Distinguish expected business-rule outcomes from exceptional failures.
- Keep operational concerns such as logging, metrics, and retries near the outer layer.

## Tooling baseline

| Concern | Preferred baseline |
| --- | --- |
| modules | standardize on one module strategy per package or clearly document mixed-mode interoperability |
| linting and formatting | one ESLint profile and one formatter path for the repository |
| static feedback | use JSDoc plus `// @ts-check` or TypeScript-aware tooling when stronger editor checks are valuable |
| tests | cover module boundaries, async flows, and untrusted-input behavior |
| packaging | make environment assumptions explicit in `package.json`, build config, and exports |

## Common red flags

- modules that mix startup side effects, I/O, parsing, and business logic in one file
- hidden reliance on `window`, `document`, `process`, or other globals without documenting the runtime assumption
- mutation-heavy objects passed through many layers with no clear ownership
- broad catch blocks that convert hard failures into mysterious `undefined` or empty results
- string-built SQL, shell commands, or HTML without explicit escaping or validation strategy
- test suites that depend on real clocks, real network access, or global execution order when seams would make them deterministic

## Review checklist

- [ ] The runtime, module model, and artifact type are identified before advice becomes specific.
- [ ] Imports and exports make dependency direction visible.
- [ ] Boundary validation exists where untrusted input enters the system.
- [ ] Async flows surface errors, timeouts, and cleanup intentionally.
- [ ] Global state and mutation are narrow and explicit.
- [ ] Formatting, linting, and tests are easy to run in CI.

## Migration playbook

- standardize the module story first so later cleanup does not fight the build chain
- move side effects toward startup edges and keep pure logic import-safe
- add validation seams around untrusted input before refactoring internal helpers
- introduce `// @ts-check` and JSDoc where richer editor feedback would remove ambiguity
- add small deterministic tests around async and boundary behavior, then simplify implementation detail

## Reference starting points

- [MDN JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)
- [MDN JavaScript modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules)
- [JSDoc](https://jsdoc.app/)
