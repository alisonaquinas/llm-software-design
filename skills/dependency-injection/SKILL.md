---
name: dependency-injection
description: >
  design, review, and refactor explicit dependency graphs, composition roots,
  and service lifetimes. use when the user asks about dependency injection,
  constructor injection, inversion of control containers, service lifetimes,
  composition roots, test seams, injection tokens, or how to avoid service
  locator and hidden dependencies in application code.
---

# Dependency Injection

Use this skill to make dependencies explicit, replaceable, and composable without obscuring the runtime graph.

## Intent Router

| Need | Load |
| --- | --- |
| composition roots, lifetimes, dependency inversion, container tradeoffs, and review checklist | `references/di-guide.md` |
| examples for .net, angular, fastapi/python, javascript/typescript, c++, c, and rust-style composition | `references/platform-examples.md` |

## Quick Start

1. Start by identifying what a unit truly depends on to do its work.
2. Prefer constructor or parameter injection for required dependencies.
3. Keep object graph construction near the application's entry point.
4. Match service lifetime to ownership, mutability, and resource scope.
5. Use containers as assembly tools, not as ambient global registries.

## Workflow

1. List the runtime collaborators, resources, and policies involved in one use case.
2. Separate stable abstractions from volatile implementations.
3. Decide which dependencies are required, optional, scoped, or factory-created.
4. Establish a composition root where the graph is built.
5. Choose the simplest injection style that keeps dependencies explicit.
6. Review lifetime rules for caches, database sessions, HTTP clients, and user/request state.
7. Remove service locator calls, static singletons, and hidden global lookups where they obscure the graph.

## Outputs to Prefer

- make dependency direction and object ownership explicit
- recommend constructor injection by default for required collaborators
- explain lifetime choices and disposal consequences
- show how testing improves when dependencies are explicit
- avoid container-specific tricks unless the framework truly requires them

## Common Requests

```text
Refactor this code to use dependency injection and explain the composition root, service lifetimes, and testing seams.
```

```text
Review this container setup or service graph for hidden dependencies, service locator behavior, or lifetime mismatches.
```

```text
Show dependency-injection patterns in .NET, Angular, FastAPI/Python, JavaScript, TypeScript, C, C++, or Rust.
```

## Safety Notes

- do not introduce a container where plain function or constructor composition is enough
- avoid service locator APIs inside domain logic or business services
- avoid singleton lifetimes for mutable request-specific state
- do not manufacture abstractions solely to satisfy a mocking tool; use them where a real boundary exists
