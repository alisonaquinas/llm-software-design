# Language-specific OOP examples

Use these examples to translate the same modeling ideas into the target language's idioms. Do not force nominal inheritance where the language offers a better fit.

## Python

### Best fit

- use `@dataclass(frozen=True)` for small immutable value objects
- use regular classes when stateful behavior and invariants belong together
- use `Protocol` for structural contracts and `abc.ABC` when you need explicit abstract bases
- prefer composition and duck typing over deep inheritance

### Example: value object plus protocol seam

```python
from __future__ import annotations

from dataclasses import dataclass
from decimal import Decimal
from typing import Protocol


@dataclass(frozen=True)
class Money:
    amount: Decimal
    currency: str

    def add(self, other: "Money") -> "Money":
        if self.currency != other.currency:
            raise ValueError("currency mismatch")
        return Money(self.amount + other.amount, self.currency)


class ReceiptSink(Protocol):
    def publish(self, order_id: str, total: Money) -> None: ...


class Order:
    def __init__(self, order_id: str) -> None:
        self.order_id = order_id
        self._total = Money(Decimal("0"), "USD")

    @property
    def total(self) -> Money:
        return self._total

    def add_line(self, line_total: Money) -> None:
        self._total = self._total.add(line_total)

    def checkout(self, sink: ReceiptSink) -> None:
        sink.publish(self.order_id, self._total)
```

### Modeling note

Prefer small value objects and protocols when behavior varies but the domain model is simple. Reach for `abc.ABC` when you need explicit inheritance hooks or shared abstract behavior.

## TypeScript

### Best fit

- use `interface` and `type` for contracts and data shape
- use classes when you need encapsulated mutable state, invariants, or lifecycle methods
- use `readonly`, access modifiers, and constructor injection to keep ownership clear
- prefer discriminated unions when the set of states or variants is closed

### Example: entity with injected collaborator

```ts
interface ReceiptSink {
  publish(orderId: string, totalCents: number): Promise<void>;
}

class Order {
  private totalCents = 0;

  constructor(
    public readonly orderId: string,
    private readonly sink: ReceiptSink,
  ) {}

  addLine(lineTotalCents: number): void {
    if (lineTotalCents < 0) {
      throw new Error("line total must be non-negative");
    }
    this.totalCents += lineTotalCents;
  }

  async checkout(): Promise<void> {
    await this.sink.publish(this.orderId, this.totalCents);
  }
}
```

### Modeling note

If the problem is only state-shape variation, a discriminated union may be clearer than a class hierarchy. Use classes when runtime identity and invariant-protecting methods are the real need.

## JavaScript

### Best fit

- remember that JavaScript is prototype-based; `class` is a clearer syntax, not a different runtime model
- use classes for stateful objects with real lifecycle or invariants
- use modules, closures, or plain objects when that is simpler than a nominal class
- prefer composition and first-class functions over inheritance-heavy designs

### Example: class with private field and explicit boundary

```javascript
class Order {
  #totalCents = 0;

  constructor(orderId, receiptSink) {
    this.orderId = orderId;
    this.receiptSink = receiptSink;
  }

  addLine(lineTotalCents) {
    if (lineTotalCents < 0) {
      throw new Error("line total must be non-negative");
    }
    this.#totalCents += lineTotalCents;
  }

  async checkout() {
    await this.receiptSink.publish(this.orderId, this.#totalCents);
  }
}
```

### Modeling note

Because JavaScript already treats functions as objects and modules as first-class organization units, do not introduce classes unless they materially improve state ownership or collaboration clarity.

## C

### Best fit

- use `struct` for grouped state and opaque pointers to hide representation
- emulate polymorphism with function pointers or tables only when open-ended runtime substitution is genuinely needed
- make lifetime rules explicit through `init`, `destroy`, `create`, and `free` functions
- keep ownership and error handling obvious; this matters more than textbook OOP purity

### Example: opaque state plus manual vtable-style seam

```c
/* notifier.h */
typedef struct notifier notifier_t;

typedef struct {
    void (*publish)(void *ctx, const char *order_id, int total_cents);
    void *ctx;
} receipt_sink_t;

notifier_t *notifier_create(const char *order_id);
void notifier_add_line(notifier_t *self, int line_total_cents);
void notifier_checkout(notifier_t *self, receipt_sink_t sink);
void notifier_destroy(notifier_t *self);
```

```c
/* notifier.c */
struct notifier {
    char order_id[32];
    int total_cents;
};

void notifier_add_line(notifier_t *self, int line_total_cents) {
    if (line_total_cents < 0) {
        return; /* or propagate an error code */
    }
    self->total_cents += line_total_cents;
}

void notifier_checkout(notifier_t *self, receipt_sink_t sink) {
    sink.publish(sink.ctx, self->order_id, self->total_cents);
}
```

### Modeling note

In C, the key OOP decisions are usually about encapsulation, ownership, and substitutable behavior. Reach for function pointers only after a simpler direct-call design stops fitting.

## C++

### Best fit

- use value types and RAII by default
- use inheritance for stable substitutable interfaces, not as a generic code-reuse mechanism
- use `std::unique_ptr` or references to make ownership explicit
- keep base classes small and behavioral; put shared data in composed members unless the base truly owns common invariants

### Example: interface plus RAII-friendly composition

```cpp
#include <memory>
#include <stdexcept>
#include <string>

struct ReceiptSink {
    virtual ~ReceiptSink() = default;
    virtual void publish(const std::string& order_id, int total_cents) = 0;
};

class Order {
public:
    Order(std::string order_id, ReceiptSink& sink)
        : order_id_(std::move(order_id)), sink_(sink) {}

    void add_line(int line_total_cents) {
        if (line_total_cents < 0) {
            throw std::invalid_argument("line total must be non-negative");
        }
        total_cents_ += line_total_cents;
    }

    void checkout() { sink_.publish(order_id_, total_cents_); }

private:
    std::string order_id_;
    int total_cents_ = 0;
    ReceiptSink& sink_;
};
```

### Modeling note

Prefer RAII value types for resources and domain values. Use inheritance only when callers benefit from a stable virtual contract and lifetime ownership is still obvious.

## C#

### Best fit

- use classes for entities and workflows with mutable identity
- use `record` or `record struct` for value objects when value equality is desired
- use interfaces at volatile boundaries such as storage, transport, or policy seams
- let dependency injection wire object graphs instead of hiding dependencies behind service locators or singletons

### Example: entity plus interface seam

```csharp
public interface IReceiptSink
{
    Task PublishAsync(string orderId, int totalCents);
}

public sealed class Order
{
    private int _totalCents;
    private readonly IReceiptSink _sink;

    public Order(string orderId, IReceiptSink sink)
    {
        OrderId = orderId;
        _sink = sink;
    }

    public string OrderId { get; }

    public void AddLine(int lineTotalCents)
    {
        if (lineTotalCents < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(lineTotalCents));
        }

        _totalCents += lineTotalCents;
    }

    public Task CheckoutAsync() => _sink.PublishAsync(OrderId, _totalCents);
}

public readonly record struct Money(decimal Amount, string Currency);
```

### Modeling note

In C#, records are often the right answer for value objects, while classes plus interfaces fit lifecycle-heavy entities and application services.

## Rust

### Best fit

- use `struct` plus `impl` for stateful domain types
- use enums for closed sets of states or variants
- use traits for shared behavior contracts and `dyn Trait` only when open-ended runtime polymorphism is needed
- prefer ownership-encoding types over inheritance; model impossible states out of existence where practical

### Example: struct plus trait boundary

```rust
trait ReceiptSink {
    fn publish(&self, order_id: &str, total_cents: i64);
}

struct Order<'a> {
    order_id: String,
    total_cents: i64,
    sink: &'a dyn ReceiptSink,
}

impl<'a> Order<'a> {
    fn new(order_id: impl Into<String>, sink: &'a dyn ReceiptSink) -> Self {
        Self {
            order_id: order_id.into(),
            total_cents: 0,
            sink,
        }
    }

    fn add_line(&mut self, line_total_cents: i64) {
        assert!(line_total_cents >= 0, "line total must be non-negative");
        self.total_cents += line_total_cents;
    }

    fn checkout(&self) {
        self.sink.publish(&self.order_id, self.total_cents);
    }
}
```

### Modeling note

Rust often favors enums, traits, and ownership-aware types over inheritance. For closed state machines, an enum is usually simpler than an object hierarchy; for open extension, traits or trait objects fit better.

## Cross-language translation rules

- if the language has strong value types or records, use them for value objects
- if the language has structural typing, consider protocols or interfaces before abstract base classes
- if resource lifetime is explicit, surface ownership and cleanup directly in the design
- if the language has enums or tagged unions, prefer them for closed variant sets instead of forced subclassing
- if the language is prototype-based or function-oriented, do not invent nominal hierarchies unless they clearly help
