# SQL documentation convention

## Preferred convention

schema object comments in DDL

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on database-native object comments for the requested surface when the dialect supports them
- document public and externally consumed schema objects before private staging tables or transient helpers
- keep summaries, column semantics, nullability expectations, and examples aligned with the real schema
- use the engine-native metadata path rather than free-form inline comments when downstream tools can query metadata directly

## Why this is the default

For SQL, the strongest machine-readable documentation is usually metadata attached to schema objects, not ad hoc prose inside query text. Engines such as PostgreSQL and Oracle provide `COMMENT ON`, SQL Server commonly uses extended properties such as `MS_Description`, and MySQL supports table and column comments in DDL. Those metadata paths are visible to schema browsers, catalog queries, and many ERD or migration tools.

## Best targets

- tables and views that other teams or services query directly
- columns whose business meaning, units, or nullability are not obvious from the name alone
- materialized views, functions, and procedures where the dialect supports metadata comments
- schemas, sequences, and constraints when they form part of a long-lived platform contract

## Dialect map

### PostgreSQL and Oracle

Prefer `COMMENT ON` statements stored with migrations.

```text
CREATE TABLE invoice (
    id bigint primary key,
    total numeric(12,2) not null
);

COMMENT ON TABLE invoice IS 'Customer invoice header.';
COMMENT ON COLUMN invoice.total IS 'Final invoice total in billing currency.';
```

### SQL Server

Prefer extended properties, commonly `MS_Description`.

```text
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Customer invoice header.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE',  @level1name = N'Invoice';
```

### MySQL

Prefer table and column `COMMENT` clauses in `CREATE TABLE` or `ALTER TABLE`.

```text
CREATE TABLE invoice (
    id bigint primary key,
    total decimal(12,2) not null COMMENT 'Final invoice total in billing currency.'
) COMMENT='Customer invoice header.';
```

## What to document

At minimum, document what callers cannot reliably infer from the object name alone:

- business meaning and intended usage
- units, currencies, or timezone semantics
- nullability meaning, especially when null has a business-specific interpretation
- status code vocabularies and lifecycle expectations
- whether a view is authoritative, derived, or compatibility-only
- any cross-system identifier semantics that matter to downstream joins

## Tooling notes

- Keep comments in migrations so schema and documentation evolve together.
- Prefer one comment source of truth per object.
- Do not store secrets or sensitive operational details in comments; many engines expose comments broadly to readers of catalog metadata.
- When the dialect lacks rich metadata comments, fall back to a structured migration header and document the limitation explicitly.

## External tool access

```text
psql -c "\d+ invoice"
query catalog views for comments
SHOW FULL COLUMNS FROM invoice;
EXEC sys.sp_addextendedproperty ...
```

## Migration guidance

- document durable shared schema objects first, not every transient temp table
- move comment metadata into migrations so it stays versioned with schema changes
- normalize wording for common column families such as timestamps, status flags, and identifiers
- verify the metadata appears in the engine's catalog views or admin tooling after changes

## Review checklist

- [ ] The chosen metadata path matches the target dialect.
- [ ] Table and column comments describe business meaning, not only repeat the object name.
- [ ] Units, nullability meaning, and identifier semantics are explicit where needed.
- [ ] Comments live in migrations or another durable schema source of truth.
- [ ] Sensitive or operationally dangerous details are not stored in broadly visible metadata comments.

## Anti-patterns

- relying only on inline `--` or `/* ... */` comments for metadata that downstream tools need to query
- documenting object names with tautologies like `customer_id = customer id`
- letting view or column comments drift after schema changes
- storing secrets, credentials, or incident notes in comment metadata
- using different documentation mechanisms for similar objects without a clear reason

## Reference starting points

- [PostgreSQL documentation](https://www.postgresql.org/docs/)
- [COMMENT in Oracle Database](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/COMMENT.html)
- [MySQL `CREATE TABLE` statement](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)
- [SQL Server documentation](https://learn.microsoft.com/en-us/sql/)
