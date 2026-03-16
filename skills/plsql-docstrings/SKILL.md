---
name: plsql-docstrings
description: >
  document pl/sql code with comment on metadata plus package-spec headers so external tools can read the embedded api documentation. use when the request is to add, normalize, migrate, review, or explain pl/sql source documentation, inline api help, or machine-readable comments.
---

# PL/SQL Docstrings

Use this skill to add or normalize COMMENT ON metadata plus package-spec headers in PL/SQL code so external tools can discover API intent without reverse-engineering the implementation.

## Intent Router

| Need | Load |
| --- | --- |
| preferred syntax, extraction path, and caveats | `references/docstrings.md` |

## Quick Start

1. Inspect the repository for an existing documentation convention.
2. Preserve an established machine-readable style when it already works with external tooling.
3. Otherwise standardize on COMMENT ON metadata plus package-spec headers for the requested PL/SQL surface.
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
CREATE TABLE invoice (
id NUMBER PRIMARY KEY,
total NUMBER(12,2) NOT NULL
);
COMMENT ON TABLE invoice IS Customer invoice header.;
COMMENT ON COLUMN invoice.total IS Final invoice total.;
```

## Extraction Path

```text
query USER_TAB_COMMENTS and USER_COL_COMMENTS
DBMS_METADATA for DDL inspection
```

## Common Requests

```text
Add or normalize PL/SQL source documentation for this public API without changing behavior.
```

```text
Review this PL/SQL file for missing or misleading machine-readable documentation that external tools depend on.
```

## Verification and Migration Checks

- verify the generated docs with the extraction path, metadata query, or generator named in `references/docstrings.md`
- compare parameter names, return values, exceptions, ownership notes, and examples against the real declaration after editing
- migrate one contiguous public surface at a time when a file mixes styles
- preserve an existing machine-readable convention when external tooling already depends on it, and state that choice explicitly

## Recovery Cues

- if the repository already standardizes on another adjacent format, keep that format instead of forcing a conversion
- if a declaration is still unstable or private, document only the parts external tools or callers actually consume
- if behavior is unclear, reduce the prose to verified facts and mark open questions instead of inventing guarantees

## Safety Notes

- do not invent behavior, preconditions, side effects, performance guarantees, or error modes that the code does not actually implement
- do not document private members unless the request, generator, or house style requires them
- do not mix competing documentation styles in the same file without a clear migration reason
- do not let examples drift away from the real API surface
