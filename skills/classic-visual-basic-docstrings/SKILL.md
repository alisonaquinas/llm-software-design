---
name: classic-visual-basic-docstrings
description: >
  document classic visual basic code with structured header comments for vbdox-style tools so external tools can read the embedded api documentation. use when the request is to add, normalize, migrate, review, or explain classic visual basic source documentation, inline api help, or machine-readable comments.
---

# Classic Visual Basic Docstrings

Use this skill to add or normalize structured header comments for VBDOX-style tools in Classic Visual Basic code so external tools can discover API intent without reverse-engineering the implementation.

## Intent Router

| Need | Load |
| --- | --- |
| preferred syntax, extraction path, and caveats | `references/docstrings.md` |

## Quick Start

1. Inspect the repository for an existing documentation convention.
2. Preserve an established machine-readable style when it already works with external tooling.
3. Otherwise standardize on structured header comments for VBDOX-style tools for the requested Classic Visual Basic surface.
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
' Name: Add
' Purpose: Add two integers.
' Parameters: a, b
Public Function Add(ByVal a As Integer, ByVal b As Integer) As Integer
Add = a + b
End Function
```

## Extraction Path

```text
VBDOX project.vbp
legacy code analysis and documentation tools
```

## Common Requests

```text
Add or normalize Classic Visual Basic source documentation for this public API without changing behavior.
```

```text
Review this Classic Visual Basic file for missing or misleading machine-readable documentation that external tools depend on.
```

## Safety Notes

- do not invent behavior, preconditions, side effects, performance guarantees, or error modes that the code does not actually implement
- do not document private members unless the request, generator, or house style requires them
- do not mix competing documentation styles in the same file without a clear migration reason
- do not let examples drift away from the real API surface
