# Pattern implementation playbook

Use this file when the user asks for concrete code, wiring guidance, or "how this pattern is actually implemented". Each section provides:

1. the problem pressure the pattern solves
2. a minimal language-agnostic shape
3. one practical implementation example
4. implementation notes, test cues, and references

For language-specific alternatives beyond the examples here, also load `references/language-examples.md`.

## Strategy

### Use when

Use strategy when one stable call site must choose between several algorithms or policies without hard-coding the choice into long branching.

### Minimal shape

```text
Strategy:
  execute(input) -> output

ConcreteStrategyA implements Strategy
ConcreteStrategyB implements Strategy

Context:
  strategy: Strategy
  run(input) -> strategy.execute(input)
```

### Practical example (Python)

```python
from typing import Protocol


class ShippingRule(Protocol):
    def cost_cents(self, weight_grams: int) -> int: ...


class FlatRate:
    def __init__(self, cents: int) -> None:
        self.cents = cents

    def cost_cents(self, weight_grams: int) -> int:
        return self.cents


class WeightBased:
    def __init__(self, cents_per_kg: int) -> None:
        self.cents_per_kg = cents_per_kg

    def cost_cents(self, weight_grams: int) -> int:
        whole_kg = max(1, (weight_grams + 999) // 1000)
        return whole_kg * self.cents_per_kg


class Checkout:
    def __init__(self, shipping_rule: ShippingRule) -> None:
        self.shipping_rule = shipping_rule

    def total_shipping(self, weight_grams: int) -> int:
        return self.shipping_rule.cost_cents(weight_grams)
```

### Implementation notes

- Inject the strategy where the variation is chosen, not deep inside the strategy itself.
- If each strategy is one small expression, accept a plain callable before introducing classes.
- The main tests should verify the context's contract and each strategy's isolated behavior.

### References

- GoF Strategy pattern: <https://www.informit.com/store/design-patterns-elements-of-reusable-object-oriented-9780201633610>
- Python structural protocols: <https://typing.python.org/en/latest/spec/protocol.html>
- Refactoring.Guru Strategy overview: <https://refactoring.guru/design-patterns/strategy>

## State

### Use when

Use state when behavior changes materially across named lifecycle modes and transitions themselves deserve to be explicit.

### Minimal shape

```text
State:
  handle(context, input)

ConcreteStateA implements State
ConcreteStateB implements State

Context:
  state: State
  transition_to(new_state)
  request(input) -> state.handle(self, input)
```

### Practical example (TypeScript)

```ts
interface DoorState {
  open(ctx: Door): void;
  close(ctx: Door): void;
  readonly name: string;
}

class Door {
  constructor(private state: DoorState) {}

  setState(state: DoorState): void {
    this.state = state;
  }

  open(): void {
    this.state.open(this);
  }

  close(): void {
    this.state.close(this);
  }

  currentState(): string {
    return this.state.name;
  }
}

class ClosedState implements DoorState {
  readonly name = "closed";

  open(ctx: Door): void {
    ctx.setState(new OpenState());
  }

  close(_: Door): void {
    throw new Error("door is already closed");
  }
}

class OpenState implements DoorState {
  readonly name = "open";

  open(_: Door): void {
    throw new Error("door is already open");
  }

  close(ctx: Door): void {
    ctx.setState(new ClosedState());
  }
}
```

### Implementation notes

- Keep transition rules close to the states if the transitions are part of the domain language.
- Prefer a discriminated union or enum when the state set is closed and the behavior stays local.
- Tests should cover both allowed transitions and illegal transitions.

### References

- GoF State pattern: <https://www.informit.com/store/design-patterns-elements-of-reusable-object-oriented-9780201633610>
- TypeScript discriminated unions: <https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-0.html>
- Rust enums and pattern matching for closed-state alternatives: <https://doc.rust-lang.org/book/ch06-00-enums.html>
- Refactoring.Guru State overview: <https://refactoring.guru/design-patterns/state>

## Facade

### Use when

Use facade when a subsystem is too noisy, broad, or fragile for most callers and you want one stable, task-oriented entry point.

### Minimal shape

```text
SubsystemA
SubsystemB
SubsystemC

Facade:
  operation(input):
    a.step1(input)
    b.step2(...)
    c.step3(...)
    return result
```

### Practical example (C#)

```csharp
public interface ITemplateEngine
{
    string RenderInvoice(Invoice invoice);
}

public interface IPdfRenderer
{
    byte[] Render(string html);
}

public interface IEmailSender
{
    Task SendAsync(string to, string subject, byte[] attachment);
}

public sealed class InvoiceDeliveryFacade
{
    private readonly ITemplateEngine _templates;
    private readonly IPdfRenderer _pdf;
    private readonly IEmailSender _email;

    public InvoiceDeliveryFacade(
        ITemplateEngine templates,
        IPdfRenderer pdf,
        IEmailSender email)
    {
        _templates = templates;
        _pdf = pdf;
        _email = email;
    }

    public async Task SendInvoiceAsync(Invoice invoice)
    {
        string html = _templates.RenderInvoice(invoice);
        byte[] pdfBytes = _pdf.Render(html);
        await _email.SendAsync(invoice.BillToEmail, $"Invoice {invoice.InvoiceNumber}", pdfBytes);
    }
}
```

### Implementation notes

- Facades should expose use-case language, not mirror every method of the subsystem.
- Keep the facade narrow; if it grows into a mirror of the underlying APIs, the abstraction is failing.
- Test the facade at the workflow level and leave deep subsystem behavior to lower-level tests.

### References

- GoF Facade pattern: <https://www.informit.com/store/design-patterns-elements-of-reusable-object-oriented-9780201633610>
- .NET dependency injection overview for wiring collaborators: <https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection/overview>
- Refactoring.Guru Facade overview: <https://refactoring.guru/design-patterns/facade>

## Decorator

### Use when

Use decorator when additional behavior must wrap a stable contract and several wrappers may need to stack independently.

### Minimal shape

```text
Component:
  run(request) -> response

ConcreteComponent implements Component

Decorator implements Component:
  inner: Component
  run(request):
    before()
    result = inner.run(request)
    after(result)
    return result
```

### Practical example (JavaScript)

```javascript
function withRetry(handler, maxAttempts = 3) {
  return async function retryingHandler(...args) {
    let lastError;

    for (let attempt = 1; attempt <= maxAttempts; attempt += 1) {
      try {
        return await handler(...args);
      } catch (error) {
        lastError = error;
      }
    }

    throw lastError;
  };
}

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

const saveOrderWithCrossCuttingBehavior = withTiming(withRetry(saveOrder), "saveOrder");
```

### Implementation notes

- Wrapper functions are often the cleanest decorator form in JavaScript and Python.
- Use class-based decorators when the wrapped contract is stateful or non-function-shaped.
- The biggest win is composability; if nothing needs to stack, a direct helper may be enough.

### References

- GoF Decorator pattern: <https://www.informit.com/store/design-patterns-elements-of-reusable-object-oriented-9780201633610>
- MDN closures: <https://developer.mozilla.org/docs/Web/JavaScript/Closures>
- Refactoring.Guru Decorator overview: <https://refactoring.guru/design-patterns/decorator>

## Adapter

### Use when

Use adapter when an existing implementation is acceptable but its interface, data shape, or call convention does not match what your code wants to depend on.

### Minimal shape

```text
Target:
  request(domain_input) -> domain_output

Adaptee:
  vendor_call(vendor_input) -> vendor_output

Adapter implements Target:
  adaptee: Adaptee
  request(domain_input):
    vendor_input = translate_in(domain_input)
    vendor_output = adaptee.vendor_call(vendor_input)
    return translate_out(vendor_output)
```

### Practical example (TypeScript)

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
```

### Implementation notes

- Keep the adapter focused on translation; do not turn it into a facade or policy layer unless needed.
- Normalize vendor-specific errors near the boundary so the rest of the code sees domain language.
- Tests should cover translation in both directions and representative vendor failures.

### References

- GoF Adapter pattern: <https://www.informit.com/store/design-patterns-elements-of-reusable-object-oriented-9780201633610>
- TypeScript interfaces: <https://www.typescriptlang.org/docs/handbook/interfaces.html>
- Refactoring.Guru Adapter overview: <https://refactoring.guru/design-patterns/adapter>

## Builder

### Use when

Use builder when construction has many optional parts, ordering or validation matters, or the target object should not exist in an invalid partially-configured state.

### Minimal shape

```text
Builder:
  set_part_a(...)
  set_part_b(...)
  build() -> Product

Client:
  builder.set_part_a(...)
         .set_part_b(...)
  product = builder.build()
```

### Practical example (Rust)

```rust
#[derive(Debug)]
struct HttpClient {
    base_url: String,
    timeout_ms: u64,
    retries: u8,
    use_tls: bool,
}

#[derive(Default)]
struct HttpClientBuilder {
    base_url: Option<String>,
    timeout_ms: Option<u64>,
    retries: u8,
    use_tls: bool,
}

impl HttpClientBuilder {
    fn new() -> Self {
        Self {
            retries: 3,
            use_tls: true,
            ..Self::default()
        }
    }

    fn base_url(mut self, value: impl Into<String>) -> Self {
        self.base_url = Some(value.into());
        self
    }

    fn timeout_ms(mut self, value: u64) -> Self {
        self.timeout_ms = Some(value);
        self
    }

    fn retries(mut self, value: u8) -> Self {
        self.retries = value;
        self
    }

    fn build(self) -> Result<HttpClient, &'static str> {
        let base_url = self.base_url.ok_or("base_url is required")?;
        Ok(HttpClient {
            base_url,
            timeout_ms: self.timeout_ms.unwrap_or(5_000),
            retries: self.retries,
            use_tls: self.use_tls,
        })
    }
}
```

### Implementation notes

- Put validation in `build()` so partially assembled state never leaks into the final product.
- Prefer named options or a plain config struct when there are only a few independent fields.
- The main builder tests should verify defaults, required fields, and validation behavior.

### References

- GoF Builder pattern: <https://www.informit.com/store/design-patterns-elements-of-reusable-object-oriented-9780201633610>
- Rust API Guidelines checklist (`C-BUILDER`): <https://rust-lang.github.io/api-guidelines/checklist.html>
- Refactoring.Guru Builder overview: <https://refactoring.guru/design-patterns/builder>

## Observer

### Use when

Use observer when one publisher must notify several dependents about the same change without hard-coding each dependent into the publisher.

### Minimal shape

```text
Observer:
  update(event)

Subject:
  subscribe(observer)
  unsubscribe(observer)
  notify(event)
```

### Practical example (Python)

```python
from collections.abc import Callable
from dataclasses import dataclass


@dataclass(frozen=True)
class InventoryChanged:
    sku: str
    on_hand: int


class Inventory:
    def __init__(self) -> None:
        self._on_hand: dict[str, int] = {}
        self._subscribers: list[Callable[[InventoryChanged], None]] = []

    def subscribe(self, handler: Callable[[InventoryChanged], None]) -> None:
        self._subscribers.append(handler)

    def adjust(self, sku: str, delta: int) -> None:
        new_total = self._on_hand.get(sku, 0) + delta
        self._on_hand[sku] = new_total
        event = InventoryChanged(sku=sku, on_hand=new_total)
        for handler in list(self._subscribers):
            handler(event)
```

### Implementation notes

- Publish stable event payloads instead of leaking mutable internal objects.
- If delivery guarantees, buffering, or cross-process fan-out matter, the real solution may be pub-sub or messaging rather than in-process observer.
- Tests should verify fan-out and ordering expectations that the code actually promises.

### References

- GoF Observer pattern: <https://www.informit.com/store/design-patterns-elements-of-reusable-object-oriented-9780201633610>
- Python dataclasses: <https://peps.python.org/pep-0557/>
- Refactoring.Guru Observer overview: <https://refactoring.guru/design-patterns/observer>

## Implementation reminders across all patterns

- Start with the smallest viable form of the pattern, not the maximal textbook diagram.
- Keep domain language in the public API and hide wiring details inside the implementation.
- Name the simpler alternative you considered and why it stopped being enough.
- Tests should validate the promised seam: interchangeability, transition safety, workflow simplification, wrapper stacking, translation correctness, validated construction, or fan-out.
