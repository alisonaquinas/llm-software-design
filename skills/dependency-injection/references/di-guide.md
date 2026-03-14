# Dependency Injection Guide


## Purpose


Dependency injection is a way to supply an object with the collaborators it needs rather than letting the object discover or construct them implicitly. Microsoft's .NET guidance frames DI as a remedy for hard-coded dependencies and a key implementation technique for dependency inversion. Sources: Microsoft Learn.  
<https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection>  
<https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection-basics>

## Design Goals



- make dependencies visible in constructors or parameters

- centralize graph assembly in one place

- decouple policies and adapters from domain logic

- improve testability by replacing boundary collaborators explicitly

- manage lifecycle and disposal coherently

## Core Concepts


### Dependency inversion

Higher-level policies should depend on abstractions, not low-level details. Microsoft architectural guidance describes dependency inversion as key to loose coupling and testability.  
<https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/architectural-principles>

### Composition root

A composition root is the entry point where the object graph is assembled. Domain code should generally not resolve dependencies from the container directly.

### Injection styles


- **Constructor injection**: default for required dependencies.

- **Method or parameter injection**: good for transient collaborators or request-specific data.

- **Property injection**: reserve for framework integration or rare optional hooks.

## Lifetime Management


Microsoft documents three primary .NET lifetimes: **Transient**, **Scoped**, and **Singleton**. The same underlying concerns exist in other ecosystems even if the names differ.  
<https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection#service-lifetimes>

### Transient

Use for small stateless services or cheap per-use objects.

### Scoped

Use for request, unit-of-work, or operation scope where one logical action should share state or disposable resources.

### Singleton

Use for truly shared stateless services, configuration snapshots, or carefully synchronized shared resources.

### Lifetime hazards


- singleton depending on scoped state

- mutable singleton caches without synchronization

- leaking request-specific identity into global services

- holding database sessions or handles longer than intended

## Containers vs Plain Composition


A DI container is optional. In many libraries or small programs, explicit assembly code is enough. Reach for a container when framework integration, graph complexity, or lifetime management benefits clearly outweigh the added indirection.

## Service Locator Smell


A service locator hides required dependencies behind a global lookup or ambient provider. Warning signs:

- methods call a global `resolve()` or `getService()` internally

- constructors appear simple but work only because hidden global state exists

- tests require global registration rather than explicit collaborators

## Framework Notes from Primary Sources


### .NET

The built-in DI container supports constructor injection, service lifetimes, and scope validation. Microsoft docs also discuss constructor selection and common registration patterns.  
<https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection>

### Angular

Angular documents DI as a way to organize and share code, improve maintainability and testability, and scope providers hierarchically. Its `InjectionToken` mechanism is especially useful for interface-like contracts where runtime types are erased. Sources: Angular docs.  
<https://angular.dev/guide/di>  
<https://angular.dev/guide/di/hierarchical-dependency-injection>  
<https://angular.dev/api/core/InjectionToken>

### FastAPI

FastAPI's dependency system uses `Depends` to provide shared logic such as authentication, database access, and common parameters. It also supports sub-dependencies. Source: FastAPI docs.  
<https://fastapi.tiangolo.com/tutorial/dependencies/>

## Review Checklist



- Are required dependencies explicit in the type's constructor or parameters?

- Is there one clear composition root?

- Do service lifetimes match state ownership and disposal rules?

- Has the design avoided service locator access in business code?

- Are abstractions protecting real boundaries such as storage, messaging, time, or external APIs?

## Common Failure Modes



- container used everywhere instead of only at assembly time

- interfaces generated for every concrete class without a substitution or boundary need

- singleton lifetime selected only for convenience

- dependency graphs that reveal classes doing too much work

- tests that mirror container configuration instead of modeling behavior
