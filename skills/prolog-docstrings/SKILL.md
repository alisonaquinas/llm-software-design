---
name: prolog-docstrings
description: >
  document prolog code with pldoc structured comments so external tools can read the embedded api documentation. use when the request is to add, normalize, migrate, review, or explain prolog source documentation, inline api help, or machine-readable comments.
---

# Prolog Docstrings

Use this skill to add or normalize PlDoc structured comments in Prolog code so external tools can discover API intent without reverse-engineering the implementation.

## Intent Router

| Need | Load |
| --- | --- |
| preferred syntax, extraction path, and caveats | `references/docstrings.md` |

## Quick Start

1. Inspect the repository for an existing documentation convention.
2. Preserve an established machine-readable style when it already works with external tooling.
3. Otherwise standardize on PlDoc structured comments for the requested Prolog surface.
4. Document public and externally consumed symbols before private helpers.
5. Keep names, parameters, return semantics, and examples aligned with the real code.

## Workflow

- identify the externally consumed surface before adding comments or rewriting existing documentation
- add documentation directly adjacent to the declaration or symbol that external tools inspect
- prefer concise summaries first, then parameters, returns, exceptions, examples, or side effects when the format supports them
- mention or preserve the extraction path used by the surrounding toolchain
- keep migrations incremental when mixed styles already exist in a large file or module

## Output Pattern

- state the convention being applied and why it matches the surrounding toolchain
- show declaration-adjacent documentation blocks rather than detached prose
- mention extraction or verification commands when they help confirm the result
- call out any symbols intentionally left undocumented because they are private or out of scope

## Canonical Pattern

```text
%! add(+A, +B, -Sum) is det.
%  Sum is the sum of A and B.
add(A, B, Sum) :-
Sum is A + B.
```

## Extraction Path

```text
swipl -g doc_server -t halt
swipl -g doc_save -t halt
```

## Common Requests

```text
Add or normalize Prolog source documentation for this public API without changing behavior.
```

```text
Review this Prolog file for missing or misleading machine-readable documentation that external tools depend on.
```

## Safety Notes

- do not invent behavior, preconditions, side effects, performance guarantees, or error modes that the code does not actually implement
- do not document private members unless the request, generator, or house style requires them
- do not mix competing documentation styles in the same file without a clear migration reason
- do not let examples drift away from the real API surface
