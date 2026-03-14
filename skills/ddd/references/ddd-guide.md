# DDD Guide


## Purpose


Domain-driven development is most valuable when the domain is complex, terminology is subtle, and mistakes in business rules are costly. Microsoft guidance for DDD-oriented systems emphasizes bounded contexts, rich domain models, and keeping infrastructure concerns outside the domain layer. Sources: Microsoft Learn and Azure Architecture Center.  
<https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/microservice-domain-model>  
<https://learn.microsoft.com/en-us/azure/architecture/microservices/model/domain-analysis>

## Strategic Design


### Subdomains


- **Core subdomain**: differentiating capability where domain insight creates business advantage.

- **Supporting subdomain**: important, but not usually the source of differentiation.

- **Generic subdomain**: commodity capability often solved with bought software or straightforward implementation.

### Bounded contexts

Azure guidance recommends identifying bounded contexts where a single ubiquitous language and model meaning stay consistent. A bounded context is both a semantic boundary and often a team/ownership boundary.  
<https://learn.microsoft.com/en-us/azure/architecture/microservices/model/domain-analysis>

Good bounded-context signals:

- the same term means different things in different parts of the business

- one team's release cadence or rules differ sharply from another's

- consistency rules apply inside a zone but not across the whole business

- data ownership is disputed or duplicated because the concept is overloaded

### Context maps

Describe how contexts relate: partnership, customer-supplier, published language, conformist integration, anti-corruption layer, or open host.

## Tactical Design


### Entities

Objects with identity and lifecycle continuity.

### Value objects

Small immutable concepts defined by attributes rather than identity.

### Aggregates

Consistency boundaries that guard invariants inside one transaction. Azure's tactical DDD guidance stresses choosing aggregate boundaries carefully because microservice and aggregate boundaries interact with autonomy and transaction cost.  
<https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-ddd>

### Domain events

Facts that the business cares about and that other parts of the model may react to. Domain events should carry business meaning, not just "row updated" style noise.

### Repositories

Microsoft guidance positions repositories as part of the domain's abstraction boundary so persistence concerns stay outside the domain model.  
<https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-persistence-layer-design>

## Aggregate Sizing Heuristics


Choose a larger aggregate when:

- an invariant truly must be enforced atomically

- stale reads would violate a core business rule

- one command must coordinate the state change synchronously

Choose separate aggregates when:

- the model is growing toward lock contention and oversized transactions

- some data changes much more frequently than the rest

- consumers only need asynchronous awareness, not immediate consistency

- one aggregate is turning into a mini-database of unrelated concerns

## Rich Domain Model vs Anemic Model


A rich model places business behavior, invariants, and decisions close to the data that owns them. An anemic model often devolves into data bags plus orchestration services that know too much.

A data-centric design may still be the right answer for simple CRUD or reporting applications. The point of DDD is not to maximize ceremony; it is to preserve meaning where complexity justifies it.

## DDD and Architecture Style


DDD does **not** require microservices. Microsoft repeatedly shows DDD patterns in systems that may later evolve into services, but the same strategic and tactical boundaries can live inside a modular monolith.  
<https://learn.microsoft.com/en-us/azure/architecture/microservices/model/domain-analysis>

## Common Failure Modes



- **Entity mirrors table**: the model is shaped by persistence, not business meaning.

- **Repository per table**: abstractions protect nothing and merely duplicate ORM APIs.

- **Aggregate too large**: every change becomes one giant transaction.

- **Aggregate too small**: invariants leak across multiple transactions with hidden race conditions.

- **Shared kernel by accident**: contexts share code because it is convenient, not because semantics are truly shared.

- **Domain events without domain meaning**: generic update notifications that force consumers to infer business significance.

## Review Checklist



- What are the core domain terms, and where do they change meaning?

- Which invariants must hold transactionally?

- What belongs in one bounded context, and what needs translation?

- Which behaviors belong in entities or aggregates rather than application services?

- Which integrations need anti-corruption layers instead of direct schema or API reuse?

## Suggested Book References



- Eric Evans, *Domain-Driven Design*

- Vaughn Vernon, *Implementing Domain-Driven Design*

- Vlad Khononov, *Learning Domain-Driven Design*
