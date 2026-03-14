# Event Sourcing Guide


## Purpose


Martin Fowler's foundational description of event sourcing frames it as capturing all changes to application state as a sequence of events that can be replayed to reconstruct past state.  
<https://martinfowler.com/eaaDev/EventSourcing.html>

Microsoft's Azure architecture guidance describes the same core idea as persisting the full series of actions in an append-only store rather than storing only the current state, and notes that the pattern is often paired with CQRS and materialized views.  
<https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing>  
<https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs>

## When It Fits Well



- strong auditability or temporal traceability requirements

- complex domains where past facts matter, not only current state

- need to rebuild derived views from history

- asynchronous integration where domain events are first-class

- need to answer "how did the state get here?" with precision

## When It Often Does Not Fit


Azure guidance explicitly cautions that event sourcing is not a good fit for simple CRUD systems or domains where the team cannot absorb additional complexity. It adds complexity in schema evolution, projections, debugging, and operations.  
<https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing>

## Core Building Blocks


### Event log

Append-only durable history of facts.

### Stream

Ordered sequence of events for one aggregate or subject.

### Aggregate

Business consistency boundary that decides which events can be appended.

### Projection / materialized view

Derived read model built from the log.

### Snapshot

State checkpoint that reduces replay cost for long-lived streams.

## Event Design Rules



- name events as completed facts: `order-submitted`, `inventory-reserved`

- include business-significant data needed to understand the fact later

- separate envelope metadata from domain payload

- include correlation and causation identifiers when workflows span multiple messages or aggregates

- define versioning and upcasting strategy early

## Concurrency and Idempotency


Most event-sourced systems rely on optimistic concurrency:

- read stream at version `n`

- decide next event(s)

- append only if the current stream version is still `n`

Idempotency matters for retried commands, duplicated messages, and projection handlers.

Dedicated event stores such as EventSourcingDB document append-only logs, strict immutability, ordering guarantees, and built-in support for optimistic concurrency and replay as first-class capabilities.  
<https://docs.eventsourcingdb.io/about-eventsourcingdb/design-principles/>  
<https://docs.eventsourcingdb.io/about-eventsourcingdb/why-eventsourcingdb/>

## Projections and Read Models


A projection should be treated as a disposable derivative of the event log. If it becomes corrupted or if the projection code changes, it should be possible to rebuild it from source events.

CQRS guidance from Azure notes that read models and write models may be intentionally different and that event stores often act as the write model's source of truth.  
<https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs>

## Snapshotting Heuristics


Use snapshots when:

- a stream is long and hot enough that replay latency matters

- aggregate reconstruction is a measurable bottleneck

- snapshot invalidation and versioning are operationally understood

Avoid snapshots when:

- they are added prematurely

- the reconstruction cost is low

- snapshots become an opaque second source of truth

## Governance and Privacy


Immutability improves auditability but complicates deletion and correction of personal data. EventSourcingDB's GDPR guidance emphasizes minimizing personal data in events and handling privacy requirements at application and operational layers rather than assuming the log can be edited later.  
<https://docs.eventsourcingdb.io/best-practices/gdpr-compliance/>

## Common Failure Modes



- events mirror storage mutations instead of business facts

- no explicit concurrency policy exists

- projections are treated as authoritative instead of rebuildable

- schema evolution is ignored until old events become unreadable

- every subsystem subscribes to generic events and must infer meaning

- event sourcing chosen for novelty rather than domain need
