---
name: idd
description: >
  design systems around stable contracts, ports, and interface boundaries.
  use when the user asks about interface-driven development, contract-first
  APIs, ports and adapters, plugin contracts, public interfaces, integration
  boundaries, interface segregation, injection tokens, or how to evolve
  contracts without leaking internal implementation details.
---

# IDD

Use this skill to shape boundaries from explicit contracts first, then fit implementations behind those contracts.

## Intent Router

| Need | Load |
| --- | --- |
| contract-first workflow, ports and adapters, interface evolution, and review checklist | `references/idd-guide.md` |
| api, plugin, and code-level examples across common platforms and languages | `references/examples.md` |

## Quick Start

1. Start from the boundary: caller needs, messages, errors, versioning, and lifecycle.
2. Keep contracts small, cohesive, and explicit about ownership.
3. Separate public interface vocabulary from internal storage or framework details.
4. Evolve interfaces compatibly whenever possible.
5. Use adapters to protect the core from transport, vendor, and legacy shapes.

## Workflow

1. Identify the boundary being designed: API, plugin, module seam, message contract, or provider token.
2. State the consumer-facing capabilities and non-capabilities.
3. Design the contract in domain language, including errors, versioning, and idempotency rules where relevant.
4. Choose an implementation pattern: abstract interface, port, trait, protocol, OpenAPI schema, or generated contract.
5. Add adapters that translate framework, transport, or legacy shapes into the contract.
6. Review interface cohesion, compatibility, and discoverability.
7. Define how the interface will be tested: contract tests, generated clients, mock servers, or fake adapters.

## Outputs to Prefer

- define contracts before showing implementation classes or tables
- explain ownership, compatibility, and versioning expectations
- keep interfaces cohesive and segregated by capability
- show how adapters isolate implementation churn
- recommend contract tests where multiple implementations or consumers exist

## Common Requests

```text
Design a stable interface or API contract for this module, plugin, or service and explain how it should evolve.
```

```text
Review this interface for leakage of internal details, oversized responsibilities, or versioning hazards.
```

```text
Show ports-and-adapters or contract-first examples in TypeScript, JavaScript, Python, C#, C++, C, or Rust.
```

## Verification and Next Steps

- verify the contract with consumer-focused examples, contract tests, or fake adapters
- show which internal details stay behind the boundary and which compatibility promise remains public
- name the additive evolution path before recommending a breaking change

## Safety Notes

- do not let database schema or framework objects become the public contract by accident
- avoid one large interface where several focused contracts would be clearer
- avoid breaking changes when additive evolution can preserve consumers
- do not let generated stubs replace interface design discipline
