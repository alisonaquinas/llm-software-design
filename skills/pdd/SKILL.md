---
name: pdd
description: >
  design asynchronous software around promises, tasks, futures, and structured
  concurrency. use when the user asks about promise-driven development,
  task-based async design, async or await patterns, cancellation, backpressure,
  concurrency limits, background workflows, or how to model modern asynchronous
  APIs in javascript, typescript, c#, python, rust, or related runtimes.
---

# PDD

Use this skill to design APIs and workflows around explicit asynchronous values and lifecycles instead of ad hoc callbacks or hidden threads.

## Intent Router

| Need | Load |
| --- | --- |
| async API design, cancellation, structured concurrency, and anti-patterns | `references/pdd-guide.md` |
| examples for javascript, typescript, c#, python, rust, and interop notes for c and c++ environments | `references/language-examples.md` |

## Quick Start

1. Start by deciding what work is asynchronous and why.
2. Represent asynchronous results explicitly as promises, tasks, futures, or streams.
3. Make cancellation, timeout, and failure behavior part of the contract.
4. Prefer structured concurrency over fire-and-forget work where accountability matters.
5. Keep sync-over-async blocking out of request and UI paths.

## Workflow

1. Identify whether the operation is one-shot, streaming, fan-out, retrying, or long-lived.
2. Choose the return shape: promise/task/future, async iterable/stream, channel, or callback bridge.
3. Define how cancellation, timeout, and partial failure behave.
4. Decide the concurrency model: sequential, bounded parallelism, queue-based work, or event loop orchestration.
5. Make resource ownership explicit across awaits, retries, and task handoff.
6. Review error aggregation, backpressure, and observability before recommending production use.
7. Prefer adapters when wrapping callback, thread, or signal-based legacy APIs into promise/task flows.

## Outputs to Prefer

- make async boundaries and lifecycles explicit
- explain failure, timeout, and cancellation semantics with the main API shape
- recommend bounded concurrency instead of unbounded fan-out
- distinguish CPU-bound work from I/O-bound work
- show how to preserve structured cleanup across awaits and task groups

## Common Requests

```text
Refactor this callback or thread-based code into promise/task-oriented async code and explain cancellation, timeout, and error handling.
```

```text
Review this async design for sync-over-async blocking, unbounded concurrency, forgotten tasks, or missing backpressure.
```

```text
Show promise/task/future patterns in JavaScript, TypeScript, C#, Python, Rust, or adjacent native runtimes.
```

## Safety Notes

- avoid fire-and-forget work unless ownership, retry, and shutdown semantics are explicit
- avoid blocking on async results inside event loops, request handlers, or UI threads
- avoid unbounded `gather`, `Task.WhenAll`, or `Promise.all` fan-out when resource pressure matters
- do not hide cancellation, timeout, or retry policy outside the contract when callers must reason about them
