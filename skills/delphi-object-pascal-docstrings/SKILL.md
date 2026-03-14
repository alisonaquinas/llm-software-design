---
name: delphi-object-pascal-docstrings
description: >
  document delphi/object pascal code with xml documentation comments so external tools can read the embedded api documentation. use when the request is to add, normalize, migrate, review, or explain delphi/object pascal source documentation, inline api help, or machine-readable comments.
---

# Delphi/Object Pascal Docstrings

Use this skill to add or normalize XML documentation comments in Delphi/Object Pascal code so external tools can discover API intent without reverse-engineering the implementation.

## Intent Router

| Need | Load |
| --- | --- |
| preferred syntax, extraction path, and caveats | `references/docstrings.md` |

## Quick Start

1. Inspect the repository for an existing documentation convention.
2. Preserve an established machine-readable style when it already works with external tooling.
3. Otherwise standardize on XML documentation comments for the requested Delphi/Object Pascal surface.
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
/// <summary>Add two integers.</summary>
/// <param name="A">Left operand.</param>
/// <param name="B">Right operand.</param>
/// <returns>Sum of the operands.</returns>
function Add(A, B: Integer): Integer;
```

## Extraction Path

```text
pasdoc source/*.pas
compiler XMLDoc generation when enabled
```

## Common Requests

```text
Add or normalize Delphi/Object Pascal source documentation for this public API without changing behavior.
```

```text
Review this Delphi/Object Pascal file for missing or misleading machine-readable documentation that external tools depend on.
```

## Safety Notes

- do not invent behavior, preconditions, side effects, performance guarantees, or error modes that the code does not actually implement
- do not document private members unless the request, generator, or house style requires them
- do not mix competing documentation styles in the same file without a clear migration reason
- do not let examples drift away from the real API surface
