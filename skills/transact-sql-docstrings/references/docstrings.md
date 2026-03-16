# Transact-SQL documentation convention

## Preferred convention

extended properties with MS_Description

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer extended properties because SQL Server tools can query them directly from metadata instead of relying on free-form comment parsing.

## Best targets

tables, columns, views, procedures, functions, schemas

## Canonical syntax

```text
EXEC sys.sp_addextendedproperty
@name = N'MS_Description',
@value = N'Customer invoice header.',
@level0type = N'SCHEMA', @level0name = N'dbo',
@level1type = N'TABLE',  @level1name = N'Invoice';
```

## Example

```text
EXEC sys.sp_addextendedproperty
@name = N'MS_Description',
@value = N'Final invoice total in billing currency.',
@level0type = N'SCHEMA', @level0name = N'dbo',
@level1type = N'TABLE',  @level1name = N'Invoice',
@level2type = N'COLUMN', @level2name = N'Total';
```


## Metadata boundaries

Use SQL Server metadata for durable schema docs and reserve inline prose for what metadata cannot express.

- Prefer `MS_Description` or another stable extended-property scheme for tables, columns, views, procedures, and functions.
- Document units, nullability meaning, status vocabularies, and identifier semantics where downstream tools need them.
- Keep stored-procedure header comments short and contract-focused when catalog metadata is not enough.
- Version metadata changes alongside schema migrations so the contract evolves with the object.
- Verify the chosen metadata path through `sys.extended_properties`, SSMS, or the schema tools the team actually uses.

## External tool access

sys.extended_properties, SSMS, ERD tooling, schema diff tools

```text
query sys.extended_properties
SSMS object properties and schema extraction tools
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

Use a predictable property name such as `MS_Description`. Supplement stored procedure metadata with a structured header comment only when catalog metadata is not enough.

## Anti-patterns

- relying only on inline comments for information schema browsers should be able to query
- using inconsistent property names across objects that should share one metadata convention
- documenting object names tautologically without business meaning, units, or null semantics
- letting procedure header comments drift away from actual parameter lists
- storing secrets, incident notes, or operational trivia in broadly visible extended properties

## Reference starting points

- [sp_addextendedproperty](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addextendedproperty-transact-sql)
- SQL Server catalog views and `sys.extended_properties` queries used by the current team
- repository conventions for migration scripts, ERDs, and SSMS-visible documentation
