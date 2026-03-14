# PDD Guide


## Scope and Terminology


The label **promise-driven development** is used here to mean designing modern asynchronous software around explicit promises, tasks, futures, and structured concurrency concepts. The key idea is that asynchronous work should be first-class in API design rather than hidden behind callbacks, ambient threads, or blocking wrappers.

## Why Explicit Async Values Matter


MDN defines a JavaScript `Promise` as an object representing the eventual completion or failure of an asynchronous operation. That core idea generalizes well across languages: `.NET Task`, Python `Task`, and Rust `Future` all make asynchronous work explicit. Sources: MDN, Microsoft Learn, Python docs, Rust async book.  
<https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise>  
<https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/task-asynchronous-programming-model>  
<https://docs.python.org/3/library/asyncio-task.html>  
<https://rust-lang.github.io/async-book/01_getting_started/04_async_await_primer.html>

## Design Goals



- make asynchrony visible in type signatures and contracts

- preserve clear error propagation and cancellation rules

- prevent unbounded concurrency from overwhelming resources

- separate I/O concurrency from CPU parallelism

- maintain structured cleanup and observability

## Contract Questions for Async APIs


### What completes the async value?


- one result

- many results over time

- background acknowledgement only

### What can cancel it?

Cancellation should be part of the contract, not an afterthought.

### What happens on timeout?

Timeout is not always the same as cancellation. Decide whether timeout aborts underlying work, merely stops waiting, or records compensating work.

### How are failures surfaced?

Decide whether failure is single, aggregated, retriable, or partial.

## Guidance from Primary Sources


### JavaScript / TypeScript

MDN's promise guide emphasizes chaining, `.catch`, and `async`/`await` as the standard model for modern asynchronous JavaScript.  
<https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Async_JS/Promises>

### C# / .NET

Microsoft's async guidance recommends `await` over directly accessing `.Result` or calling `.Wait()` because blocking harms responsiveness and readability. It also documents task-based asynchronous programming as the main .NET pattern.  
<https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/>  
<https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/task-asynchronous-programming-model>

### Python

Python's `asyncio` documentation provides `Task`, `TaskGroup`, `create_task`, `gather`, `wait_for`, and stream primitives for structured asynchronous programming.  
<https://docs.python.org/3/library/asyncio-task.html>

### Rust

The async book explains that `async fn` returns a `Future`, which makes progress only when polled by an executor, and highlights the value of running many concurrent tasks on a small number of OS threads for I/O-bound work.  
<https://rust-lang.github.io/async-book/01_getting_started/02_why_async.html>  
<https://rust-lang.github.io/async-book/01_getting_started/04_async_await_primer.html>

## Structured Concurrency Heuristics


Prefer a parent scope that owns spawned child work:

- task groups

- async scopes

- request-scoped cancellation

- bounded worker pools

This keeps shutdown, cancellation, and error aggregation understandable.

## Common Failure Modes



- **sync-over-async**: blocking on `Task.Result`, `Wait`, or similar wrappers inside async code paths

- **forgotten tasks**: creating work without tracking completion, failure, or shutdown

- **unbounded fan-out**: launching too many concurrent calls without limits

- **mixed CPU and I/O assumptions**: using async to hide heavy CPU work without offloading or chunking it properly

- **hidden retries**: repeated side effects without idempotency or caller awareness

## Review Checklist



- Is the async boundary explicit in the type signature?

- Are cancellation and timeout semantics defined?

- Is concurrency bounded where resource usage matters?

- Does cleanup happen predictably if one branch fails?

- Should the API expose a stream instead of buffering everything into one promise/task?
