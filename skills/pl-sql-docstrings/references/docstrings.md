# PL/SQL documentation convention

## Preferred convention

COMMENT ON metadata plus package-spec headers

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer database-native COMMENT metadata for schema objects and package-spec headers for procedural APIs because external tools can query the dictionary instead of scraping source text alone.

## Best targets

tables, columns, views, packages, package specs, public functions

## Canonical syntax

```text
CREATE TABLE invoice (
id NUMBER PRIMARY KEY,
total NUMBER(12,2) NOT NULL
);
COMMENT ON TABLE invoice IS Customer invoice header.;
COMMENT ON COLUMN invoice.total IS Final invoice total.;
```

## Example

```text
CREATE OR REPLACE PACKAGE report_api AS
  /* Build the current report snapshot. */
  FUNCTION build(p_request_id IN NUMBER) RETURN report_snapshot_t;
END report_api;
/
```

## External tool access

data dictionary views, schema browsers, migration tools

```text
query USER_TAB_COMMENTS and USER_COL_COMMENTS
DBMS_METADATA for DDL inspection
```

## Migration guidance

- convert declaration-adjacent comments incrementally so mixed-style files can be cleaned up safely over time
- avoid mixing competing documentation styles in one file unless a staged migration explicitly requires it
- verify generated docs, IDE help, or extracted metadata after making documentation changes

## Review checklist

- [ ] the chosen convention matches the surrounding toolchain or house style
- [ ] comments are attached to the declarations that external tools inspect
- [ ] summaries describe real behavior without invented guarantees
- [ ] parameters, returns, errors, and examples match the code
- [ ] extraction or verification commands are noted when they materially help review or CI

## Notes

Use package specifications as the documentation boundary. Keep package body commentary focused on implementation details.
