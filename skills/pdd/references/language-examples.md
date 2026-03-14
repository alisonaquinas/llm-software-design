# Promise / Task / Future Examples


## JavaScript / TypeScript


```ts
export async function fetchQuote(id: string, signal?: AbortSignal): Promise<Quote> {
  const response = await fetch(`/api/quotes/${id}`, { signal });
  if (!response.ok) throw new Error(`quote fetch failed: ${response.status}`);
  return response.json() as Promise<Quote>;
}
```

### Notes


- Surface cancellation through `AbortSignal`.

- Keep retries explicit and pair them with idempotency where side effects exist.

## Bounded parallelism in JavaScript


```ts
const limit = pLimit(5);
const results = await Promise.all(ids.map(id => limit(() => fetchQuote(id))));
```

The key design point is the bound, not the specific helper library.

## C# / .NET


```csharp
public async Task<Quote> FetchQuoteAsync(string id, CancellationToken cancellationToken)
{
    using var response = await _httpClient.GetAsync($"quotes/{id}", cancellationToken);
    response.EnsureSuccessStatusCode();
    return await response.Content.ReadFromJsonAsync<Quote>(cancellationToken: cancellationToken)
           ?? throw new InvalidOperationException("Missing payload.");
}
```

### Notes


- Include `CancellationToken` on async operations that may outlive the caller.

- Avoid `.Result` and `.Wait()` on request or UI paths.

## Python (`asyncio`)


```python
import asyncio

async def fetch_all(ids: list[str]) -> list[str]:
    async with asyncio.TaskGroup() as tg:
        tasks = [tg.create_task(fetch_one(item_id)) for item_id in ids]
    return [task.result() for task in tasks]
```

### Notes


- `TaskGroup` clarifies ownership of child tasks.

- For bounded concurrency, wrap the call path with a semaphore or worker queue.

## Rust (`Future` + Tokio-style thinking)


```rust
async fn fetch_quote(client: &Client, id: &str) -> Result<Quote, Error> {
    let response = client.get(format!("/quotes/{id}")).send().await?;
    let quote = response.json::<Quote>().await?;
    Ok(quote)
}
```

### Notes


- Futures are lazy until polled by an executor.

- Prefer `join!`, `try_join!`, or task groups carefully, with bounded spawning where load matters.

## Wrapping C callback APIs


```c
typedef void (*completion_fn)(int status, void* context);
void begin_download(const char* url, completion_fn on_complete, void* context);
```

A PDD-oriented adapter wraps callback completion into a promise/task/future so callers can reason about cancellation and composition explicitly.

## C++ Bridge Example (`std::future`-style)


```cpp
std::future<Result> start_work(Executor& executor, Input input);
```

For modern C++ codebases, explicit sender/receiver or coroutine-based models may offer stronger composition than raw futures, but the same contract questions still apply: completion, cancellation, timeout, and ownership.
