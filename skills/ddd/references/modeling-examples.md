# DDD Modeling Examples


## Example Domain: Order Fulfillment


### Core vocabulary


- **Order**: customer commitment to purchase items.

- **Reservation**: inventory promise for an order line.

- **Shipment**: dispatch unit controlled by fulfillment.

- **Payment authorization**: approval to charge, controlled by payments.

### Potential bounded contexts


- **Ordering**: cart-to-order submission, pricing, customer intent.

- **Payments**: authorization, capture, risk checks.

- **Inventory**: stock availability and reservations.

- **Fulfillment**: picking, packing, shipment lifecycle.

The same term "status" may mean very different things across these contexts; that is a warning against one shared omnimodel.

## Aggregate Example


### C#-style aggregate root

```csharp
public sealed class Order
{
    private readonly List<OrderLine> _lines = new();

    public OrderId Id { get; }
    public OrderState State { get; private set; } = OrderState.Draft;

    public void Submit()
    {
        if (_lines.Count == 0) throw new DomainException("Order must contain at least one line.");
        if (State != OrderState.Draft) throw new DomainException("Only draft orders can be submitted.");

        State = OrderState.Submitted;
        Raise(new OrderSubmitted(Id));
    }
}
```

### Rust-style value object and command boundary

```rust
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Money {
    amount_cents: i64,
    currency: String,
}

impl Money {
    pub fn new(amount_cents: i64, currency: impl Into<String>) -> Result<Self, String> {
        if amount_cents < 0 {
            return Err("money cannot be negative".into());
        }
        Ok(Self { amount_cents, currency: currency.into() })
    }
}
```

### Python-style domain service

```python
class CreditPolicy:
    def approve(self, customer_rating: int, requested_amount: int) -> bool:
        return customer_rating >= 700 and requested_amount <= 50_000
```

Use a domain service when a rule spans concepts and does not naturally belong to one entity or value object.

## Repository Boundary Example


```typescript
export interface OrderRepository {
  findById(id: string): Promise<Order | null>;
  save(order: Order): Promise<void>;
}
```

The repository expresses the domain's persistence needs without exposing ORM details.

## Anti-Corruption Layer Example


When a legacy ERP exposes `customerType = "A" | "B" | "C"`, the new ordering context should translate that to a domain concept such as `VipTier` rather than leaking ERP codes through the whole model.

```javascript
function mapLegacyCustomerType(code) {
  switch (code) {
    case "A": return "platinum";
    case "B": return "gold";
    default: return "standard";
  }
}
```

## Event Example


Good domain event:

- `InventoryReservationExpired`

Weak technical event:

- `ReservationRowUpdated`

The first tells other contexts what happened in business language. The second leaks storage detail and forces inference.
