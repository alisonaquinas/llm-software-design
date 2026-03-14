# Language-specific code smell examples

## Python

Common smells:


- long “service” functions that validate, query, transform, and send notifications in one block

- broad `except Exception:` handlers that hide failure modes

- implicit globals such as module-level configuration, cached sessions, or mutable singletons

- repeated dictionary shape checks where a dataclass or validated object should exist

### Example

```python
def create_user(payload):
    if "email" not in payload:
        raise ValueError("email required")
    if "role" not in payload:
        raise ValueError("role required")

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO users ...")
    conn.commit()

    print(f"created {payload['email']}")
    send_welcome_email(payload["email"])
```text

This mixes validation, persistence, logging, and notification. First split validation and persistence, then inject the side-effecting collaborators.

## TypeScript

Common smells:


- `any` or `as` chains that bypass the type system

- repeated `switch (kind)` logic across reducers, services, and renderers

- giant interfaces that every implementation only partially uses

- large objects with many optional fields instead of discriminated unions

### Example

```ts
interface RequestContext {
  user?: User;
  tenant?: string;
  requestId?: string;
  logger?: Logger;
  metrics?: Metrics;
  cache?: Cache;
  flags?: Flags;
}
```text

A “context bag” with many optional fields is a smell when most consumers need only two or three of them. Split the API by role or pass explicit dependencies.

## JavaScript

Common smells:


- modules that reach into DOM, storage, network, and formatting libraries directly

- callback or promise chains with business rules embedded in transport code

- copy-pasted request setup and error mapping

- hidden state through mutated module globals

### Example

```js
let currentToken = null;

export async function fetchOrders(userId) {
  if (!currentToken) currentToken = await refreshToken();
  const response = await fetch(`/api/orders/${userId}`, {
    headers: { Authorization: `Bearer ${currentToken}` },
  });
  return response.json();
}
```text

The hidden token lifecycle makes behavior order-dependent. Extract an auth adapter or pass a token provider explicitly.

## C

Common smells:


- repeated cleanup code on every error path

- implicit ownership rules that live only in comments

- monolithic functions that parse, allocate, transform, and free resources

- huge structs passed everywhere as catch-all context

### Example

```c
int load_file(const char *path, char **out) {
    FILE *f = fopen(path, "rb");
    if (!f) return -1;

    char *buffer = malloc(4096);
    if (!buffer) {
        fclose(f);
        return -1;
    }

    if (fread(buffer, 1, 4096, f) == 0) {
        free(buffer);
        fclose(f);
        return -1;
    }

    *out = buffer;
    fclose(f);
    return 0;
}
```text

The smell is not the use of C; it is repeated cleanup logic and implicit ownership. Centralize cleanup with a single exit path or smaller helpers.

## C++


Common smells:


- raw ownership with `new` and `delete` spread across callers

- base classes that carry state and operations some derived types cannot honor

- “manager” classes with many collaborators and mixed responsibilities

- duplicated loops that should use algorithms, ranges, or reusable value types

### Example

```cpp
class ReportManager {
public:
    void run();
    void save();
    void print();
    void email();
    void archive();
private:
    Database db_;
    SmtpClient smtp_;
    Printer printer_;
    Logger log_;
};
```text

This is a classic large-class smell. Split workflow coordination from rendering, persistence, and delivery mechanisms.

## C #
Common smells:


- services with many constructor dependencies

- `NotImplementedException` in interface implementations

- static helper classes that hide clock, config, or I/O dependencies

- DTOs with validation and domain rules scattered in controllers

### Example

```csharp
public sealed class BillingService
{
    public BillingService(
        IClock clock,
        ILogger<BillingService> logger,
        IPricingClient pricing,
        ICustomerRepository customers,
        IInvoiceRepository invoices,
        IFeatureFlags flags,
        IAuditWriter audit,
        IEmailSender email) { }
}
```text

A dependency list this long is often a smell of mixed responsibilities. Group cohesive concerns or split the service along workflow boundaries.

## Rust

Common smells:


- repeated `match` logic over the same enum in many modules

- excessive `.clone()` or `Arc<Mutex<_>>` added just to escape ownership design issues

- traits that try to be both generic-friendly and trait-object-friendly without a clear API story

- `unwrap()` chains in library code or non-test paths

### Example

```rust
fn handle(event: &Event) {
    match event {
        Event::Created(x) => save_created(x),
        Event::Deleted(x) => save_deleted(x),
        Event::Updated(x) => save_updated(x),
    }
}

fn render(event: &Event) -> String {
    match event {
        Event::Created(x) => render_created(x),
        Event::Deleted(x) => render_deleted(x),
        Event::Updated(x) => render_updated(x),
    }
}
```text

One match may be fine. Repeated matches across modules often signal missing methods on the enum, missing trait-based dispatch, or a missing central registry.

## Tooling signals by language


- Python: ruff, mypy, pyright, pytest characterization tests

- TypeScript/JavaScript: TypeScript `strict`, ESLint, test snapshots or characterization tests around public behavior

- C/C++: clang-tidy, compiler warnings at high levels, sanitizers, focused regression tests around resource lifetimes

- C#: Roslyn analyzers, nullable reference types, unit tests around interface contracts and service seams

- Rust: Clippy, rustfmt, cargo test, contract-style tests for traits and adapters
