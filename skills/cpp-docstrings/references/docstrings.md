# C++ documentation convention

## Preferred convention

Doxygen comment blocks

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code
- place comments on public declarations, usually in headers or exported module interfaces

## Why this is the default

C++ has no language-native API docstring facility comparable to Python or Rust, so the most widely interoperable convention is a structured Doxygen block. Doxygen-style comments are well supported in traditional C++ codebases and remain useful even when modern tools also index AST information.

## Best targets

- public classes, structs, concepts, enums, and aliases
- exported functions and methods
- templates and generic utilities with non-obvious constraints
- public constants and macros that shape the supported API
- module interface declarations when using C++20 modules

## What to document

Document the semantics callers need, not the implementation mechanics they can already read:

- ownership and lifetime requirements
- exception behavior or error-reporting contract
- thread-safety expectations
- value categories, mutability, and aliasing expectations when relevant
- template parameter meaning and constraints
- units, valid ranges, and invariants for important values

## Canonical syntax

```text
/**
 * @brief Build the next render frame.
 * @param scene Immutable scene state.
 * @return Prepared frame packet.
 */
FramePacket build_frame(const Scene& scene);
```

## Template example

```text
/**
 * @brief Find the first element matching a predicate.
 * @tparam Range Input range type.
 * @tparam Predicate Callable used to test each element.
 * @param range Source range.
 * @param predicate Match predicate.
 * @return Iterator to the first matching element or `end(range)`.
 */
template <class Range, class Predicate>
auto find_first(Range&& range, Predicate predicate);
```

## Tooling notes

- Use `@tparam` for meaningful template parameters.
- Use `@throws` only when exceptions are part of the contract; do not invent them.
- For view-returning APIs, note lifetime expectations explicitly when callers could misuse them.
- Prefer declaration-site docs in public headers and avoid redundant copies on out-of-line definitions.

## External tool access

```text
doxygen Doxyfile
clang-doc --public include/**/*.hpp
```

## Migration guidance

- convert detached comments into declaration-adjacent documentation blocks
- document the supported public surface before private helper internals
- standardize wording for ownership, exception safety, and thread-safety across similar APIs
- verify generated docs and IDE hover help after making changes

## Review checklist

- [ ] The comment is attached to the declaration that downstream tools index.
- [ ] Parameter names and template parameter names match the declaration exactly.
- [ ] Lifetime, ownership, and exception semantics are explicit when they matter.
- [ ] Examples and return-value language match the real API behavior.
- [ ] Generic constraints are described where callers would otherwise guess.

## Anti-patterns

- documenting implementation files while the public header stays opaque
- repeating syntax already visible in the declaration while omitting contract semantics
- copying comments between overloads without checking whether semantics actually differ
- describing view or iterator results without saying anything about lifetime or invalidation
- using vague phrases like "fast" or "safe" without defining the boundary or condition

## Reference starting points

- [Doxygen documentation blocks](https://www.doxygen.nl/manual/docblocks.html)
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- [C++ reference](https://en.cppreference.com/w/cpp)
