# Language-specific SOLID examples

## Adapting SOLID by language

Do not assume every language wants nominal interfaces and inheritance. The same design pressure can be addressed with protocols, traits, function tables, modules, or simple callables.

## Python

Python favors **protocols, callables, and context managers** over elaborate class hierarchies.

### SRP + DIP example

```python
from dataclasses import dataclass
from typing import Protocol


class InvoiceStore(Protocol):
    def save(self, invoice: dict) -> None: ...


class Notifier(Protocol):
    def send(self, invoice: dict) -> None: ...


@dataclass
class InvoiceService:
    store: InvoiceStore
    notifier: Notifier

    def submit(self, invoice: dict) -> None:
        validate(invoice)
        self.store.save(invoice)
        self.notifier.send(invoice)
```

`InvoiceService` owns workflow, while storage and notification details stay behind protocols. That supports SRP and DIP without forcing inheritance.

### ISP example

Prefer small protocols such as `Readable`, `Writable`, or `Clock` over one broad service protocol that every fake and implementation must satisfy.

## TypeScript

TypeScript favors **structural interfaces, discriminated unions, and registry objects**.

### OCP example

```ts
interface PaymentHandler {
  authorize(amount: number): Promise<void>;
}

class CardHandler implements PaymentHandler {
  async authorize(amount: number) { /* ... */ }
}

class WireHandler implements PaymentHandler {
  async authorize(amount: number) { /* ... */ }
}

const handlers: Record<string, PaymentHandler> = {
  card: new CardHandler(),
  wire: new WireHandler(),
};

export async function authorize(kind: string, amount: number) {
  const handler = handlers[kind];
  if (!handler) throw new Error(`unsupported payment type: ${kind}`);
  await handler.authorize(amount);
}
```

Adding a new payment type extends the registry rather than spreading `switch` edits across the codebase.

### ISP + LSP example

If one interface mixes `read`, `write`, `delete`, and `watch`, split it into role-based interfaces so implementations can fully honor the contracts they claim to support.

## JavaScript

JavaScript favors **module seams, plain objects, closures, and adapters**.

### DIP example

```js
export function makeOrderService({ inventory, payments, clock }) {
  return {
    async place(order) {
      await inventory.reserve(order.lines);
      await payments.charge(order.total);
      return { ...order, placedAt: clock.now() };
    },
  };
}
```

The service depends on capabilities supplied from the outside instead of importing concrete vendor modules directly.

### SRP example

Avoid one module that validates input, talks to the DOM, formats currency, and calls `fetch`. Split workflow from presentation and transport.

## C

C often expresses SOLID through **modules, opaque structs, callback tables, and explicit ownership boundaries** rather than class hierarchies.

### DIP example

```c
typedef struct logger_vtable {
    void (*info)(void *ctx, const char *message);
} logger_vtable;

typedef struct logger {
    void *ctx;
    logger_vtable vt;
} logger;

typedef struct order_service {
    logger log;
} order_service;
```

High-level code talks to a function table instead of a concrete logging backend.

### SRP example

Keep parsing, validation, and resource cleanup in separate helpers. When one function opens files, parses records, and applies business rules, it usually has multiple reasons to change.

## C++

C++ supports classic interface-based SOLID, but modern practice usually prefers **RAII, value types, and composition** first.

### ISP + DIP example

```cpp
struct IClock {
    virtual ~IClock() = default;
    virtual std::chrono::system_clock::time_point now() const = 0;
};

class SessionService {
public:
    explicit SessionService(const IClock& clock) : clock_(clock) {}
    Session start() const { return Session{clock_.now()}; }
private:
    const IClock& clock_;
};
```

The service depends on a minimal abstraction. The seam is small, explicit, and testable.

### LSP example

Prefer composition over inheriting from a base class that carries state or behavior a subtype cannot honor. If some derived classes need to reject base operations, the base abstraction is probably wrong.

## C#

C# naturally supports SOLID with **interfaces, records, decorators, and explicit dependency injection**.

### SRP signal

If a service constructor needs many collaborators, it may be doing too much.

### DIP + OCP example

```csharp
public interface IReportRenderer
{
    string Render(Report report);
}

public sealed class ReportService
{
    private readonly IEnumerable<IReportRenderer> _renderers;

    public ReportService(IEnumerable<IReportRenderer> renderers) => _renderers = renderers;
}
```

New renderers can be added without rewriting the service. C# makes this pattern especially natural with DI containers, but the architectural value is the abstraction boundary, not the container itself.

## Rust

Rust usually maps SOLID onto **traits, enums, generics, and module boundaries**. Inheritance is not the default tool.

### ISP + LSP example

```rust
trait Reader {
    fn read(&mut self, buf: &mut [u8]) -> std::io::Result<usize>;
}

trait Writer {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize>;
}
```

Small traits are easier to implement honestly and easier to combine than one large “stream” trait with unrelated responsibilities.

### DIP example

Prefer domain code that depends on a trait such as `Clock`, `Repository`, or `Notifier`, with concrete adapters at the boundary. For public APIs, decide early whether a trait should be used via generics, trait objects, or both, because object safety and ergonomics differ.

## Cross-language review prompts

- what is the smallest stable seam that would isolate the volatile dependency here?
- does the abstraction describe behavior every implementation can fully honor?
- is a simple module or function parameter enough, or is a reusable interface or trait justified?
- would one new requirement force edits in many places, or just the addition of one new implementation?
