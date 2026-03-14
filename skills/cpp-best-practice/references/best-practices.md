# C++ best practices

## Scope

- Start by confirming the C++ standard level, compiler family, exception model, and target environment before giving specific guidance.
- Distinguish library code, application code, game or realtime code, embedded code, and ABI-sensitive shared-library code because their tradeoffs differ.
- Prefer project-local conventions when they are already automated and internally consistent.
- Use the defaults below when the repository has no clear standard.

## Version and environment gates

Confirm these first because they materially change the recommendations:

- **Language floor**: C++11 through C++23 or newer.
- **Compiler family**: GCC, Clang, MSVC, or vendor compiler.
- **Exception policy**: exceptions enabled, disabled, or heavily constrained.
- **Target model**: hosted vs freestanding, realtime constraints, plugin ABI, or cross-platform library.

## Review priorities

- identify correctness and behavior-preservation constraints before recommending stylistic cleanup
- prefer conventions that make ownership, dependencies, and change seams easier to understand
- keep project-local standards when they are already automated and internally consistent
- distinguish core language guidance from framework, engine, and platform rules
- treat lifetime, exception safety, and API clarity as design topics rather than syntax preferences

## Default design choices

### Resource management and ownership

- Prefer RAII for every owned resource, not only memory.
- Use standard library value types first.
- Prefer `std::unique_ptr` for exclusive ownership and use `std::shared_ptr` only when shared lifetime is truly part of the design.
- Avoid raw owning pointers in new code.
- Make borrowing vs owning semantics obvious in names and types.

### API design

- Prefer clear invariants, strong types, and descriptive parameter objects over flag arguments and sentinel values.
- Use `enum class`, dedicated structs, and wrappers to encode meaning.
- Keep interfaces small and intention-revealing.
- Be deliberate with `noexcept`, `explicit`, `constexpr`, and `const` because they affect both semantics and optimization.

### Containers, views, and ranges

- Prefer standard containers and algorithms over handwritten loops when they improve clarity.
- Use `std::span` or `std::string_view` for non-owning views only when the underlying lifetime is obvious and safe.
- Keep iterator invalidation and view lifetime risks visible in the review.
- Prefer value-returning helpers when move semantics make them cheap enough.

### Templates and generic code

- Use templates and concepts to express reusable relationships, not to hide unclear APIs.
- Keep error messages and call-site readability in mind.
- Prefer simpler compile-time mechanisms when template metaprogramming stops clarifying the design.
- Separate generic library design concerns from ordinary business logic.

## Tooling baseline

| Concern | Preferred baseline |
| --- | --- |
| formatting | one `clang-format` profile for the repository |
| warnings | aggressive warnings across supported compilers |
| static analysis | `clang-tidy` or equivalent checks for lifetime, modernize, and bug-prone patterns |
| runtime checking | AddressSanitizer and UndefinedBehaviorSanitizer where feasible |
| tests | focused unit tests plus integration tests around ABI and concurrency-sensitive code |

## Common red flags

- naked `new` and `delete` in ordinary application code
- APIs that hide ownership, lifetime, or thread-safety assumptions
- broad use of `shared_ptr` where a single owner would be clearer
- custom containers or utility types that duplicate standard-library behavior without a hard reason
- non-owning views returned from objects whose lifetime cannot be proven at the call site
- template cleverness that obscures contracts or makes diagnostics unusable

## Review checklist

- [ ] The language floor, compiler family, exception model, and target environment are identified first.
- [ ] Ownership and lifetime semantics are visible in the API design.
- [ ] RAII handles resources consistently, including files, locks, and handles.
- [ ] Standard-library types and algorithms are preferred where they improve clarity.
- [ ] `noexcept`, move behavior, and view lifetimes are reviewed intentionally.
- [ ] Warnings, static analysis, sanitizers, and tests are easy to run in CI.

## Migration playbook

- clean up warnings and sanitizer failures before chasing stylistic modernization
- replace raw owning pointers and manual cleanup with RAII seams where behavior can be preserved
- untangle lifetime and ownership ambiguity before refactoring template detail
- introduce strong types and small parameter objects where call sites are currently opaque
- add tests around exception, move, and lifetime-sensitive behavior before simplifying code

## Reference starting points

- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- [C++ reference](https://en.cppreference.com/w/cpp)
- [Doxygen documentation blocks](https://www.doxygen.nl/manual/docblocks.html)
