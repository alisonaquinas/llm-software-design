# IDD Examples


## API-First Example (OpenAPI Sketch)


```yaml
openapi: 3.1.0
info:
  title: pricing-api
  version: 1.0.0
paths:
  /quotes:
    post:
      operationId: createQuote
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateQuoteRequest'
      responses:
        '201':
          description: quote created
components:
  schemas:
    CreateQuoteRequest:
      type: object
      required: [customerId, items]
      properties:
        customerId:
          type: string
        items:
          type: array
          items:
            type: object
```

Design the consumer-facing schema first; generate docs or mocks after the contract is reviewed.

## TypeScript Port Example


```ts
export interface PaymentGateway {
  authorize(amountCents: number, currency: string): Promise<{ authorizationId: string }>;
}

export class CheckoutService {
  constructor(private readonly gateway: PaymentGateway) {}
}
```

The application depends on the port, while Stripe, Adyen, or a fake test adapter sits behind it.

## Python Protocol Example


```python
from typing import Protocol

class Clock(Protocol):
    def now_unix_seconds(self) -> int: ...
```

Protocols are useful when the contract matters more than inheritance hierarchy.

## C# Interface + Adapter Example


```csharp
public interface IShipmentNotifier
{
    Task NotifyShippedAsync(OrderId orderId, CancellationToken cancellationToken);
}

public sealed class EmailShipmentNotifier : IShipmentNotifier
{
    // adapts SMTP or provider SDK details behind the contract
}
```

## Rust Trait Port Example


```rust
pub trait EventPublisher {
    fn publish(&self, event: DomainEvent) -> Result<(), PublishError>;
}
```

## C Plugin Boundary Example


```c
typedef struct {
    int (*initialize)(void* context);
    int (*handle_request)(const char* payload, char** response);
    void (*shutdown)(void* context);
} plugin_api_v1;
```

Define lifecycle, ownership, error rules, and versioning up front.

## Angular Injection Token Example


```ts
export interface ExchangeRatesClient {
  latest(base: string): Promise<Record<string, number>>;
}

export const EXCHANGE_RATES_CLIENT = new InjectionToken<ExchangeRatesClient>(
  'EXCHANGE_RATES_CLIENT'
);
```

The token is part of the boundary. Concrete providers remain replaceable.
