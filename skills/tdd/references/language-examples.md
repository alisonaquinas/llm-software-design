# TDD Language Examples


## Python (`pytest`)


### Test-first sequence

```python
# test_price_rules.py

from pricing import subtotal


def test_subtotal_sums_line_items() -> None:
    assert subtotal([10.00, 12.50]) == 22.50
```

```python
# pricing.py

from collections.abc import Iterable


def subtotal(amounts: Iterable[float]) -> float:
    return sum(amounts)
```

### Notes


- Start with a pure function when possible.

- Move clocks, repositories, HTTP clients, or random generators behind parameters or narrow objects only when a test proves the seam is needed.

## TypeScript (`vitest` or `jest`)


```ts
import { describe, expect, it } from "vitest";
import { isEligibleForDiscount } from "./pricing";

describe("isEligibleForDiscount", () => {
  it("returns true when the cart total reaches the threshold", () => {
    expect(isEligibleForDiscount(100)).toBe(true);
  });
});
```

```ts
export function isEligibleForDiscount(total: number): boolean {
  return total >= 100;
}
```

### Notes


- Prefer plain functions and small modules over class extraction in early cycles.

- Add ports or interfaces when boundary replacement becomes real, not speculative.

## JavaScript (`jest`)


```javascript
const { normalizeSku } = require("./sku");

test("normalizeSku trims whitespace and uppercases", () => {
  expect(normalizeSku(" ab-12 ")).toBe("AB-12");
});
```

```javascript
function normalizeSku(value) {
  return value.trim().toUpperCase();
}

module.exports = { normalizeSku };
```

## C (`Unity`-style example)


```c
#include "unity.h"
#include "inventory.h"

void test_inventory_is_empty_initially(void) {
    Inventory inv;
    inventory_init(&inv);
    TEST_ASSERT_TRUE(inventory_is_empty(&inv));
}
```

```c
void inventory_init(Inventory* inv) {
    inv->count = 0;
}

bool inventory_is_empty(const Inventory* inv) {
    return inv->count == 0;
}
```

### Notes


- TDD in C often pushes state into explicit structs and dependencies into function pointers or parameterized modules.

- Prefer narrow adapter layers around OS calls, allocators, and hardware access.

## C++ (`GoogleTest`)


```cpp
#include <gtest/gtest.h>
#include "slug.h"

TEST(SlugTests, ReplacesSpacesWithHyphens) {
    EXPECT_EQ(slugify("hello world"), "hello-world");
}
```

```cpp
#include <string>

std::string slugify(const std::string& value) {
    auto out = value;
    std::replace(out.begin(), out.end(), ' ', '-');
    return out;
}
```

### Notes


- Use value types and pure transformations early.

- Introduce interfaces, templates, or polymorphism only after multiple tests prove a real variability point.

## C# (`xUnit`)


```csharp
using Xunit;

public sealed class TaxCalculatorTests
{
    [Fact]
    public void Returns_zero_for_zero_amount()
    {
        Assert.Equal(0m, TaxCalculator.For(0m, 0.07m));
    }
}
```

```csharp
public static class TaxCalculator
{
    public static decimal For(decimal subtotal, decimal rate) => subtotal * rate;
}
```

### Notes


- Let failing tests drive extraction of domain services, policies, and repository ports.

- Keep EF Core and ASP.NET plumbing outside the first design loop unless the behavior is truly framework-bound.

## Rust (`cargo test`)


```rust
pub fn normalize_email(value: &str) -> String {
    value.trim().to_lowercase()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn normalizes_case_and_whitespace() {
        assert_eq!(normalize_email(" Alice@EXAMPLE.COM "), "alice@example.com");
    }
}
```

### Notes


- Traits are useful once tests reveal a real collaborator boundary, such as clock, store, or publisher.

- Keep ownership and borrowing concerns from leaking into tests unless they are part of the domain contract.

## Cross-Language Heuristics



- Start with values and behaviors before introducing mocks.

- Use one failing test to force one design move.

- Prefer stable domain-language assertions over framework-specific details.

- After three or four tests, inspect duplication and names before adding another behavior.
