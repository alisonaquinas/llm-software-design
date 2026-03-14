# SQL documentation convention

## Preferred convention

schema object comments in DDL

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer database-native schema comments when the dialect supports them because external tools can read them from the system catalog instead of scraping free-form SQL comments.

## Best targets

tables, views, columns, materialized views, sequences, functions where supported

## Canonical syntax

```text
CREATE TABLE invoice (
id bigint primary key,
total numeric(12,2) not null
);

COMMENT ON TABLE invoice IS Customer invoice header.;
COMMENT ON COLUMN invoice.total IS Final invoice total in billing currency.;
```

## Example

```text
CREATE VIEW active_invoice AS
SELECT * FROM invoice WHERE total > 0;

COMMENT ON VIEW active_invoice IS Invoices with a non-zero balance.;
```

## External tool access

schema browsers, catalog queries, migration tooling, ERD generators

```text
psql -c "\d+ invoice"
query catalog views for comments
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

When the target database does not support COMMENT ON, preserve a structured header block in migrations and document the fallback explicitly.
