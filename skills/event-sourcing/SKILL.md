---
name: event-sourcing
description: >
  design systems that persist state as ordered domain events and derive current
  views through replay or projections. use when the user asks about event
  sourcing, append-only event stores, optimistic concurrency, stream design,
  snapshots, projections, cqrs, audit trails, or how to implement event-sourced
  patterns in sql, postgresql, sql server, mysql, mongodb, cosmos db, or
  dedicated event stores.
---

# Event Sourcing

Use this skill to model domain history as append-only events, choose stream boundaries, and design reliable projections and replay workflows.

## Intent Router

| Need | Load |
| --- | --- |
| event-sourcing fundamentals, stream design, concurrency, snapshots, and caveats | `references/event-sourcing-guide.md` |
| database-specific patterns for sql, postgresql, sql server, mysql, mongodb, cosmos db, and dedicated event stores | `references/database-examples.md` |

## Quick Start

1. Start from business facts that must be preserved over time.
2. Choose stream boundaries from aggregate consistency rules, not from table convenience.
3. Treat append-only writes and optimistic concurrency as core design decisions.
4. Keep read models disposable and rebuildable from the event log.
5. Use snapshots and projection checkpoints only when replay cost justifies them.

## Workflow

1. Identify the domain events that represent meaningful business facts.
2. Define the stream or subject key, event ordering rules, and expected concurrency model.
3. Specify event envelope fields: id, stream key, version, type, timestamp, payload, metadata, and causation/correlation identifiers where needed.
4. Design write rules around optimistic concurrency and idempotency.
5. Design projections and materialized views around actual read needs.
6. Add snapshotting only after measuring long-stream replay or hot-aggregate cost.
7. Review privacy, retention, schema evolution, and operational replay needs before production rollout.

## Outputs to Prefer

- name events as business facts in past tense
- explain stream boundaries, ordering rules, and concurrency expectations
- separate write model, event log, and read model concerns clearly
- show how rebuilding, replay, and backfilling work operationally
- recommend ordinary CRUD when event sourcing adds more complexity than value

## Common Requests

```text
Design an event-sourced model for this domain, including events, stream keys, optimistic concurrency, and projections.
```

```text
Review this schema or architecture for event-sourcing pitfalls, including event naming, snapshot misuse, or projection coupling.
```

```text
Show event-sourcing patterns for PostgreSQL, SQL Server, MySQL, MongoDB, Cosmos DB, or a dedicated event store.
```

## Verification and Next Steps

- verify append ordering, optimistic concurrency, replay, and projection rebuild behavior with one concrete stream
- show the idempotency or duplicate-delivery rule for writes and projections
- name the retention, privacy, or schema-evolution concern that needs explicit governance before rollout

## Safety Notes

- do not choose event sourcing for a simple CRUD system without a real need for history, replay, or complex temporal reasoning
- avoid events that merely mirror row mutations without business meaning
- avoid coupling projections so tightly that rebuilding becomes dangerous or impossible
- avoid storing sensitive mutable personal data in immutable events unless governance and redaction strategy are explicit
