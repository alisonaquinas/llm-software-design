# Language-specific pattern examples

Use these examples to map pattern intent into the target language's idioms. Each example is deliberately small; expand only when the real problem needs more structure.

## Python

### Typical fit

- strategy is often simplest as a callable or `Protocol`

- decorator can be a wrapper object or a function decorator depending on whether stateful wrapping is needed

- observer often works well with callback lists, signals, or async event hooks

- builder is less common when keyword arguments and dataclasses already express configuration clearly

### Strategy example

```python
from typing import Protocol


class PriceRule(Protocol):
    def apply(self, subtotal_cents: int) -> int: ...


class TenPercentOff:
    def apply(self, subtotal_cents: int) -> int:
        return subtotal_cents - (subtotal_cents // 10)


class Checkout:
    def __init__(self, rule: PriceRule) -> None:
        self.rule = rule

    def total(self, subtotal_cents: int) -> int:
        return self.rule.apply(subtotal_cents)
```text

### Pattern note

If each strategy is only one expression, accept a plain callable instead of a whole class hierarchy.

## TypeScript

### Typical fit


- strategies and adapters map cleanly to interfaces

- decorators can be wrapper classes or middleware chains

- factories fit well when object creation depends on configuration or discriminated unions

- state often competes with discriminated unions; use the union form when the state set is closed

### Adapter example

```ts
interface PaymentGateway {
  charge(cents: number): Promise<string>;
}

class VendorApi {
  async createPayment(input: { amountInCents: number }): Promise<{ id: string }> {
    return { id: `pay_${input.amountInCents}` };
  }
}

class VendorPaymentAdapter implements PaymentGateway {
  constructor(private readonly api: VendorApi) {}

  async charge(cents: number): Promise<string> {
    const result = await this.api.createPayment({ amountInCents: cents });
    return result.id;
  }
}
```text

### Pattern note

When the mismatch is only data-shape translation, a small adapter like this is enough; do not add factories or facades unless the surrounding subsystem is also unstable or noisy.

## JavaScript

### Typical fit


- first-class functions often replace formal strategy and command classes

- decorators frequently become wrapper functions, middleware, or proxies

- module boundaries can act like facades naturally

- observer is often event-based, but direct callbacks may be enough for local coordination

### Decorator example

```javascript
function withTiming(handler, label) {
  return async function timedHandler(...args) {
    const started = Date.now();
    try {
      return await handler(...args);
    } finally {
      console.log(`${label} took ${Date.now() - started}ms`);
    }
  };
}

async function saveOrder(order) {
  return `saved:${order.id}`;
}

const saveOrderWithTiming = withTiming(saveOrder, "saveOrder");
```text

### Pattern note

This is still a decorator pattern even though it is expressed as a higher-order function instead of wrapper classes.

## C

### Typical fit


- strategy and state are often implemented with function pointers and explicit context pointers

- adapter is usually a thin wrapper around a third-party API or device driver

- command fits when actions must be queued or retried explicitly

- pattern cost is high, so use the fewest moving parts possible

### Strategy example

```c
typedef int (*price_rule_fn)(void *ctx, int subtotal_cents);

typedef struct {
    price_rule_fn apply;
    void *ctx;
} price_rule_t;

int ten_percent_off(void *ctx, int subtotal_cents) {
    (void)ctx;
    return subtotal_cents - (subtotal_cents / 10);

}

int checkout_total(price_rule_t rule, int subtotal_cents) {
    return rule.apply(rule.ctx, subtotal_cents);
}
```text

### Pattern note

Function pointers are powerful but costly in readability. Prefer direct calls until the substitution boundary is real.

## C++


### Typical fit


- strategy, decorator, and adapter fit naturally with small abstract interfaces and RAII-owned wrappers

- builder is useful when construction has many optional parts and invariants must hold before use

- state may be modeled with polymorphism or with `std::variant`; prefer `std::variant` when the state set is closed

- resource-handling patterns should respect RAII first

### Decorator example

```cpp
#include <memory>
#include <string>

struct Writer {
    virtual ~Writer() = default;
    virtual void write(const std::string& value) = 0;
};

class LoggingWriter final : public Writer {
public:
    explicit LoggingWriter(std::unique_ptr<Writer> inner)
        : inner_(std::move(inner)) {}

    void write(const std::string& value) override {
        std::cout << "writing: " << value << '\n';
        inner_->write(value);
    }

private:
    std::unique_ptr<Writer> inner_;
};
```text

### Pattern note

This decorator is worthwhile only when wrappers need to stack. For one-off logging, a direct helper may be simpler.

## C #
### Typical fit


- strategy, decorator, and adapter work well with interfaces and DI containers

- command fits naturally for UI actions, background jobs, retries, or pipelines

- builder is useful for complex immutable object graphs or fluent configuration APIs

- state can be expressed with classes, but enums plus switch expressions may be clearer for closed state sets

### Decorator example

```csharp
public interface IOrderStore
{
    Task SaveAsync(Order order);
}

public sealed class LoggingOrderStore : IOrderStore
{
    private readonly IOrderStore _inner;
    private readonly ILogger<LoggingOrderStore> _logger;

    public LoggingOrderStore(IOrderStore inner, ILogger<LoggingOrderStore> logger)
    {
        _inner = inner;
        _logger = logger;
    }

    public async Task SaveAsync(Order order)
    {
        _logger.LogInformation("Saving order {OrderId}", order.OrderId);
        await _inner.SaveAsync(order);
    }
}
```text

### Pattern note

DI makes decorator composition cheap in C#, but only use it when the wrapper behavior is reusable and cross-cutting.

## Rust

### Typical fit


- strategy can be traits, generics, or function parameters depending on whether dispatch must be dynamic

- state often competes with enums and typestate; use enums for closed sets and traits or trait objects for open extension

- decorator is commonly a wrapper struct that implements the same trait as the inner type

- builder is common for constructing complex configuration safely

### State-pattern example

```rust
trait PublishState {
    fn can_read(&self) -> bool;
}

struct Draft;
struct Published;

impl PublishState for Draft {
    fn can_read(&self) -> bool { false }
}

impl PublishState for Published {
    fn can_read(&self) -> bool { true }
}

struct Post<S: PublishState> {
    state: S,
    body: String,
}

impl Post<Draft> {
    fn publish(self) -> Post<Published> {
        Post { state: Published, body: self.body }
    }
}
```text

### Pattern note

In Rust, typestate or enums often model state more safely than classic inheritance-style state objects. Use trait objects only when the state set must stay open.

## Cross-language translation rules


- use first-class functions when the pattern is really about behavior selection rather than object identity

- use enums or tagged unions when the state or variant set is closed

- use interfaces, traits, or protocols when the variation must remain open

- use builders only when constructors or configuration objects stop being readable

- adapt patterns to the language's ownership, typing, and module system instead of copying canonical class diagrams
