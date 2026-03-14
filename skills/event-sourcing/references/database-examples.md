# Database Examples for Event Sourcing


## Common Event Envelope


A practical event envelope usually includes:

- `event_id`

- `stream_id` or `subject`

- `stream_version`

- `event_type`

- `occurred_at`

- `payload`

- `metadata`

- optional `correlation_id` and `causation_id`

## PostgreSQL / General SQL Pattern


### Table sketch

```sql
create table event_store (
  event_id uuid primary key,
  stream_id text not null,
  stream_version bigint not null,
  event_type text not null,
  occurred_at timestamptz not null,
  payload jsonb not null,
  metadata jsonb not null default '{}'::jsonb,
  unique (stream_id, stream_version)
);
```

### Projection table sketch

```sql
create table order_summary (
  order_id text primary key,
  status text not null,
  total_cents bigint not null,
  updated_at timestamptz not null
);
```

### Notes


- `unique (stream_id, stream_version)` supports optimistic concurrency.

- `jsonb` is useful when event shapes differ across types while still allowing indexed query strategies for selected fields. PostgreSQL documents JSON/JSONB support and related indexing options.  
  <https://www.postgresql.org/docs/current/datatype-json.html>

- Keep write-side queries simple: append by stream, read stream in order.

- Build read concerns into projections, not by scanning the full event table for every request.

### SQL Server / MySQL variation

Use the same logical shape with `nvarchar(max)` or `json` payload columns depending on engine capability. Keep the append-only rule and unique stream-version constraint intact.

## MongoDB Pattern


### Collection sketch

```json
{
  "_id": "evt_01H...",
  "streamId": "order-123",
  "streamVersion": 4,
  "eventType": "order-paid",
  "occurredAt": "2026-03-14T12:00:00Z",
  "payload": { "amountCents": 1299, "currency": "USD" },
  "metadata": { "correlationId": "cmd-456" }
}
```

### Notes


- Index on `streamId` + `streamVersion`.

- Keep one document per event for clean append semantics.

- MongoDB's schema design guidance stresses choosing patterns based on access patterns and tradeoffs rather than applying one pattern blindly.  
  <https://www.mongodb.com/docs/manual/data-modeling/design-patterns/>

- For high-volume time-series style projections or archive-oriented views, MongoDB's bucket pattern can help on the read side, but avoid hiding the original append-only event semantics.  
  <https://www.mongodb.com/docs/manual/data-modeling/design-patterns/group-data/bucket-pattern/>

## Azure Cosmos DB Pattern


Microsoft's Cosmos DB event-sourcing sample shows an append-only container, partitioning by aggregate key such as cart ID, querying a stream ordered by event timestamp, and using change feed plus materialized views for the read side.  
<https://learn.microsoft.com/en-us/samples/azure-samples/cosmos-db-design-patterns/event-sourcing/>

### Practical notes


- partition by aggregate or cart key when per-stream ordering and local reads matter

- use change feed consumers to update projections asynchronously

- design projections so they can be rebuilt from the container if handlers change

## Dedicated Event Store Pattern


EventSourcingDB documents subjects as stream identifiers, append-only semantics, immutability, snapshot support, replay, and strict ordering guarantees.  
<https://docs.eventsourcingdb.io/fundamentals/subjects/>  
<https://docs.eventsourcingdb.io/about-eventsourcingdb/consistency-guarantees/>

Dedicated event stores reduce implementation burden when replay, global ordering, optimistic concurrency, or event subscriptions are central to the system.

## Projection Example


```python
for event in stream:
    if event["event_type"] == "order-created":
        summary[event["stream_id"]] = {"status": "created", "total": 0}
    elif event["event_type"] == "line-added":
        summary[event["stream_id"]]["total"] += event["payload"]["line_total_cents"]
    elif event["event_type"] == "order-cancelled":
        summary[event["stream_id"]]["status"] = "cancelled"
```

Treat projection code as disposable and replayable.
