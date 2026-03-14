---
name: ddd
description: >
  model complex business domains using bounded contexts, ubiquitous language,
  aggregates, value objects, and domain events. use when the user asks about
  domain-driven development, service boundaries shaped by domain concepts,
  rich domain models, context maps, repositories, anti-corruption layers,
  strategic design, or tactical modeling in complex domains.
---

# DDD

Use this skill to shape software around domain language and business boundaries instead of around tables, endpoints, or framework layers.

## Intent Router

| Need | Load |
| --- | --- |
| strategic design, bounded contexts, aggregates, repositories, and domain events | `references/ddd-guide.md` |
| modeling examples and translations into python, typescript, javascript, c#, and rust style code | `references/modeling-examples.md` |

## Quick Start

1. Start by naming the domain, subdomains, actors, and core business decisions.
2. Look for language that different teams use differently; that often marks a bounded context seam.
3. Model invariants and transactional consistency before designing APIs or tables.
4. Keep infrastructure and transport concerns outside the domain model.
5. Use domain events to represent facts the business cares about, not generic CRUD notifications.

## Workflow

1. Capture the main domain terms, policies, lifecycle states, and conflicts in plain language.
2. Separate core, supporting, and generic subdomains.
3. Propose bounded contexts with clear ownership and translation seams.
4. Within each context, identify entities, value objects, aggregates, and domain services.
5. Define aggregate invariants and the commands that may change state.
6. Choose repositories, factories, and anti-corruption layers only where those abstractions protect the model.
7. When the domain grows beyond one context, describe the context map and the integration style between contexts.

## Outputs to Prefer

- use the domain's vocabulary consistently and define overloaded terms explicitly
- tie boundaries to ownership, invariants, and language drift
- explain aggregate size in terms of transaction and consistency rules
- keep persistence, UI, and messaging concerns outside the heart of the model
- recommend simpler data-centric designs when the domain is straightforward and stable

## Common Requests

```text
Identify bounded contexts, aggregates, and domain events for this business problem and explain the tradeoffs.
```

```text
Review this service or schema design for an anemic model, leaky context boundaries, or missing ubiquitous language.
```

```text
Map this domain model into Python, TypeScript, JavaScript, C#, or Rust without losing domain intent.
```

## Safety Notes

- do not force full DDD ceremony onto a simple CRUD or reporting domain
- avoid aggregates that are large enough to become hidden distributed transactions
- avoid repositories that merely mirror every table without protecting domain language or invariants
- do not treat bounded contexts as a synonym for microservices; a modular monolith can host many contexts
