# IDD Guide


## Scope and Terminology


The label **interface-driven development** is used inconsistently across the industry. In this repository, it means **designing stable contracts first** and then implementing adapters, providers, or services behind those contracts. That includes:


- API-first and contract-first service design

- ports-and-adapters or hexagonal architecture boundaries

- plugin or extension contracts

- interface or trait-based seams inside an application

## Why Start from Interfaces


Alistair Cockburn's original hexagonal architecture article argues that an application should be testable and operable without depending directly on a UI or database, using ports and adapters to isolate the core.  
<https://alistair.cockburn.us/hexagonal-architecture>

Microsoft API design guidance similarly recommends that APIs act as contracts and avoid exposing internal implementation details or mirroring the internal database schema.  
<https://learn.microsoft.com/en-us/azure/architecture/microservices/design/api-design>

Together these sources support a practical IDD rule: **shape the boundary in terms of consumer meaning, not internal implementation convenience**.

## Contract Design Principles


### Cohesion

Each interface should represent one capability cluster. Oversized contracts create forced coupling and make compatibility harder.

### Segregation

The Interface Segregation Principle argues against forcing implementers to depend on methods they do not need. Microsoft guidance on SOLID highlights this directly.  
<https://learn.microsoft.com/en-us/archive/msdn-magazine/2014/may/csharp-best-practices-dangers-of-violating-solid-principles-in-csharp>

### Compatibility

Prefer additive evolution when possible:

- add fields rather than removing them

- add endpoints or operations rather than mutating old semantics in place

- preserve old versions until consumers can migrate

### Discoverability

A good contract makes capabilities, preconditions, and error shapes obvious.

### Ownership

Make it clear who owns the contract, who can approve changes, and what compatibility promise exists.

## Contract-First Variants


### API-first

OpenAPI or schema-first design allows teams to discuss shape, docs, mocks, and client generation before implementation. Microsoft's OpenAPI explainer notes that specs can drive documentation, test cases, and client libraries.  
<https://learn.microsoft.com/en-us/microsoft-cloud/dev/dev-proxy/concepts/what-is-openapi-spec>

### Service-contract-first (.NET/WCF heritage)

Microsoft documents contract-first tools that generate code from existing schemas or service contracts, illustrating the broader contract-first pattern even in older service stacks.  
<https://learn.microsoft.com/en-us/dotnet/framework/wcf/contract-first-tool>

### Plugin or extension interfaces

Thunder's interface-driven documentation provides a strong example from plugin architecture: write a single interface definition, use composition over monolithic interfaces, and evolve interfaces compatibly.  
<https://rdkcentral.github.io/Thunder/plugin/interfaces/interfaces/>

## Ports and Adapters Pattern


In a ports-and-adapters model:

- the **port** is the interface the core depends on

- the **adapter** translates a concrete technology into that interface

- the core remains ignorant of HTTP, database drivers, UI widgets, or vendor SDKs

This is especially valuable when:

- multiple delivery mechanisms exist (CLI, HTTP, batch, tests)

- multiple providers may be swapped over time

- a legacy system must be wrapped without contaminating the core model

## Common Failure Modes



- public contract mirrors a table or ORM model

- plugin/API contract depends on framework-specific types

- one shared interface is used across contexts with diverging meanings

- generated stubs become the contract instead of reflecting it

- no explicit compatibility policy exists, so breaking changes arrive accidentally

## Review Checklist



- What consumer problem does the interface solve?

- Are the operations cohesive or is the boundary overloaded?

- Does the contract expose internal storage or framework details?

- How will changes be versioned and communicated?

- Are contract tests or mock servers needed to keep providers and consumers aligned?
