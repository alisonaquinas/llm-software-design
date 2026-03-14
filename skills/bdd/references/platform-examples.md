# BDD Platform Examples


## Gherkin Template


```gherkin
Feature: Discount eligibility

  Scenario: Gold customer receives a loyalty discount
    Given a customer with gold status
    And a cart subtotal of 120 dollars
    When checkout pricing is calculated
    Then the loyalty discount should be 12 dollars
```

## Python (`behave` or `pytest-bdd`)


### Scenario

```gherkin
Scenario: Locked user cannot sign in
  Given a locked user account
  When a sign-in request is submitted
  Then access should be denied
```

### Step sketch

```python
from behave import given, when, then

@given("a locked user account")
def step_locked_user(context):
    context.account = {"locked": True}

@when("a sign-in request is submitted")
def step_sign_in(context):
    context.result = {"status": "denied" if context.account["locked"] else "ok"}

@then("access should be denied")
def step_denied(context):
    assert context.result["status"] == "denied"
```

## JavaScript / TypeScript (`@cucumber/cucumber`)


```ts
import { Given, When, Then } from "@cucumber/cucumber";
import assert from "node:assert/strict";

let total = 0;
let eligible = false;

Given("a cart subtotal of {int} dollars", function (amount: number) {
  total = amount;
});

When("discount eligibility is checked", function () {
  eligible = total >= 100;
});

Then("the cart should be discount eligible", function () {
  assert.equal(eligible, true);
});
```

### Notes


- Keep browser selectors out of the scenario text.

- Prefer API or domain-level step bindings unless the purpose of the scenario is specifically end-user interaction.

## C# (`Reqnroll`)


```gherkin
Scenario: Shipment cannot be marked delivered before dispatch
  Given an undispached shipment
  When delivery is confirmed
  Then the request should be rejected
```

```csharp
using FluentAssertions;
using Reqnroll;

[Binding]
public sealed class ShipmentSteps
{
    private Shipment _shipment = new();
    private Result _result = Result.Ok();

    [Given("an undispached shipment")]
    public void GivenAnUndispatchedShipment()
    {
        _shipment = Shipment.New();
    }

    [When("delivery is confirmed")]
    public void WhenDeliveryIsConfirmed()
    {
        _result = _shipment.ConfirmDelivery();
    }

    [Then("the request should be rejected")]
    public void ThenTheRequestShouldBeRejected()
    {
        _result.IsRejected.Should().BeTrue();
    }
}
```

### Notes


- Place business rules in domain code, not in step definitions.

- Use Reqnroll dry-run in CI to catch unbound or stale scenarios early.

## API-Level BDD Example


```gherkin
Scenario: Duplicate idempotency key returns original result
  Given a payment request with idempotency key "abc-123"
  And the payment has already been accepted
  When the same payment request is sent again
  Then the original acceptance response should be returned
```

This scenario is often clearer and faster at HTTP or service level than through UI automation.

## BDD + Lower-Level Tests Split


Use Gherkin for the rule:

- gold customers receive 10 percent discount after threshold

Use ordinary code tests for:

- decimal rounding branches

- currency conversion edge cases

- null handling and parser failures

- internal caching behavior
