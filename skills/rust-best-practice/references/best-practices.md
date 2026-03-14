# Rust best practices

## Scope

- Start by confirming the Rust edition, MSRV policy, runtime model, and `std` availability before giving specific guidance.
- Distinguish library crates, binaries, embedded or `no_std` code, async services, proc macros, and FFI layers because their tradeoffs differ.
- Prefer project-local conventions when they are already automated and internally consistent.
- Use the defaults below when the repository has no clear standard.

## Version and environment gates

Confirm these first because they materially change the recommendations:

- **Edition**: 2018, 2021, or 2024.
- **MSRV policy**: whether the repository must support an older compiler.
- **Runtime model**: sync, Tokio or another async runtime, `no_std`, embedded, or FFI-heavy crate.
- **Unsafe surface**: whether `unsafe` is isolated or part of the core design.

## Review priorities

- identify correctness and behavior-preservation constraints before recommending stylistic cleanup
- prefer conventions that make ownership, dependencies, and change seams easier to understand
- keep project-local standards when they are already automated and internally consistent
- distinguish general Rust guidance from framework, runtime, and domain-specific rules
- treat ownership, error modeling, and `unsafe` boundaries as first-class API design concerns

## Default design choices

### Encode invariants in types

- Prefer types that make invalid states harder to represent.
- Use newtypes, enums, smart constructors, and dedicated error types when they clarify the contract.
- Borrow before cloning when ownership can stay with the caller.
- Prefer explicit domain types over raw strings, integers, or tuples once meaning matters.

### Error handling

- Use `Result` and `Option` deliberately.
- Reserve panics for bugs, impossible states, or very constrained APIs where panic is explicitly part of the contract.
- Add context at boundaries rather than converting everything to generic strings too early.
- Keep fallible parsing and I/O near the edge so internal code can rely on validated types.

### `unsafe` and low-level code

- Keep `unsafe` blocks small, documented, and surrounded by safe abstractions.
- State the safety invariant clearly where the `unsafe` block appears or in the enclosing API docs.
- Prefer standard library and community-proven abstractions before rolling custom pointer-heavy designs.
- Separate FFI and representation-sensitive code from higher-level business logic.

### Traits and generics

- Use traits to express real behavioral contracts, not only to avoid naming a concrete type.
- Keep generics readable and error messages tolerable.
- Prefer simple bounds and composition before advanced type-level cleverness.
- Be intentional about owned vs borrowed return values.

## Tooling baseline

| Concern | Preferred baseline |
| --- | --- |
| formatting | `cargo fmt --check` |
| linting | `cargo clippy` with repository-specific denied lints |
| tests | `cargo test`, including integration tests and doc tests where appropriate |
| docs | `cargo doc` and doc-link validation |
| API hygiene | consider `missing_docs` and other rustdoc lints on public crates |

## Common red flags

- cloning values to escape borrow-checker design questions instead of clarifying ownership
- panics used as routine validation in library code
- `unsafe` spread across many call sites instead of isolated in one abstraction boundary
- large enums, trait objects, or generic signatures that obscure the actual contract
- leaking runtime-specific assumptions into otherwise general-purpose APIs
- documentation examples that compile only by accident or no longer match the crate surface

## Review checklist

- [ ] The edition, MSRV policy, runtime model, and `std` availability are identified first.
- [ ] Types encode important invariants instead of pushing all validation to comments.
- [ ] Error handling uses `Result` and `Option` intentionally, with panics kept exceptional.
- [ ] `unsafe` is minimal, justified, and wrapped in safe interfaces.
- [ ] Borrowing, ownership, and cloning decisions are visible and defensible.
- [ ] `cargo fmt`, `cargo clippy`, tests, and docs are easy to run in CI.

## Migration playbook

- establish `fmt`, `clippy`, and test gates before large mechanical edits
- model error and ownership contracts clearly before trying to micro-optimize implementation detail
- isolate `unsafe` and FFI seams before touching the safe higher-level code
- replace ad hoc strings and tuples with newtypes or enums where invariants matter
- add tests and doctests around public APIs before modernizing internals

## Reference starting points

- [Rust Style Guide](https://doc.rust-lang.org/stable/style-guide/)
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- [The rustdoc book](https://doc.rust-lang.org/rustdoc/)
