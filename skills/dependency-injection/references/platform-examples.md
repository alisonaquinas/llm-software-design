# Dependency Injection Platform Examples


## .NET (`IServiceCollection`)


```csharp
builder.Services.AddScoped<IOrderRepository, SqlOrderRepository>();
builder.Services.AddScoped<SubmitOrderHandler>();
```

```csharp
public sealed class SubmitOrderHandler
{
    private readonly IOrderRepository _orders;
    private readonly IClock _clock;

    public SubmitOrderHandler(IOrderRepository orders, IClock clock)
    {
        _orders = orders;
        _clock = clock;
    }
}
```

### Notes


- Use constructor injection for required collaborators.

- Keep `IServiceProvider` out of domain and application services.

## Angular (`InjectionToken`)


```ts
import { InjectionToken } from '@angular/core';

export interface Clock {
  now(): Date;
}

export const CLOCK = new InjectionToken<Clock>('CLOCK');
```

```ts
providers: [
  { provide: CLOCK, useValue: { now: () => new Date() } },
]
```

Angular's `InjectionToken` is useful when interfaces disappear at runtime and a concrete token is needed for the injector.

## FastAPI / Python


```python
from fastapi import Depends, FastAPI

app = FastAPI()

class OrderRepository:
    def save(self, order_id: str) -> None:
        pass


def get_repository() -> OrderRepository:
    return OrderRepository()


@app.post("/orders/{order_id}")
def create_order(order_id: str, repo: OrderRepository = Depends(get_repository)):
    repo.save(order_id)
    return {"ok": True}
```

### Notes


- Keep domain services independent of FastAPI by passing collaborators explicitly beneath the endpoint layer.

## TypeScript / JavaScript (manual composition)


```ts
interface Mailer {
  send(subject: string, body: string): Promise<void>;
}

class WelcomeService {
  constructor(private readonly mailer: Mailer) {}

  async sendWelcomeEmail(): Promise<void> {
    await this.mailer.send("Welcome", "Hello");
  }
}

const service = new WelcomeService(new SesMailer());
```

Manual composition is often enough. A container is optional.

## C (function pointer seam)


```c
typedef int (*clock_now_fn)(void);

typedef struct {
    clock_now_fn now;
} Clock;

int expires_at(Clock clock, int ttl_seconds) {
    return clock.now() + ttl_seconds;
}
```

C often expresses injected dependencies as function tables, context structs, or explicit callback parameters.

## C++ (constructor injection)


```cpp
class Clock {
public:
    virtual ~Clock() = default;
    virtual std::chrono::system_clock::time_point now() const = 0;
};

class SessionService {
public:
    explicit SessionService(const Clock& clock) : clock_(clock) {}
private:
    const Clock& clock_;
};
```

### Notes


- Prefer references or smart pointers that make ownership clear.

- Introduce virtual dispatch only where runtime substitution is truly needed.

## Rust (trait-based composition)


```rust
trait Clock {
    fn now_unix_seconds(&self) -> i64;
}

struct SessionService<C: Clock> {
    clock: C,
}
```

Rust often expresses DI through generic parameters, trait objects, or explicit module composition rather than container-centric patterns.
