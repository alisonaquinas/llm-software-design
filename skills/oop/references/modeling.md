## Modeling Heuristics

- Use entities when identity matters across time.
- Use value objects when equality and immutability communicate intent.
- Use services for coordination that does not naturally belong on one object.
- Hide mutable state behind methods that preserve invariants.
- Prefer explicit collaboration over global access or hidden side effects.
