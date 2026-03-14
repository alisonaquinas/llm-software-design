# BDD Guide


## Purpose


Behavior-driven development uses concrete examples to align business intent, product language, and automated verification. Cucumber describes BDD as a collaborative process that helps business and technical roles reach a shared understanding through examples and executable specifications. Sources: Cucumber BDD pages.  
<https://cucumber.io/docs/bdd/>  
<https://cucumber.io/docs/guides/10-minute-tutorial/>

Martin Fowler's "GivenWhenThen" article remains one of the clearest short explanations of scenario structure as a readable form of specification by example.  
<https://martinfowler.com/bliki/GivenWhenThen.html>

## What BDD Is Good At



- clarifying acceptance behavior before implementation

- creating a shared language between product, QA, and engineering

- capturing domain rules as examples instead of only prose requirements

- exposing ambiguity early, before automation cements the wrong behavior

## What BDD Is Not



- a replacement for unit tests

- a reason to express every edge case in Gherkin

- a guarantee that UI automation is the right level

- a synonym for writing verbose end-to-end test suites

## Scenario Quality Rules


### One behavior per scenario

A scenario should normally show one rule, outcome, or contract. If multiple outcomes matter, split them.

### Stable domain language

Step text should survive refactoring of selectors, service calls, or method names.

### Observable outcomes

Then-steps should talk about visible state, emitted events, messages, or user-visible results, not private object internals.

### Right execution level

Many scenarios are clearer and faster at API or component level than through full browser automation.

### Meaningful examples

Examples should be chosen to reveal rules: boundaries, happy path, denial cases, state transitions, or exception policies.

## Given / When / Then Heuristics


### Given

Use for meaningful preconditions, not every setup detail. Hidden technical setup can live in fixtures or hooks.

### When

Capture the trigger or event. Prefer one meaningful action.

### Then

State the observable outcome. If the system emits an event, changes a status, or returns a decision, assert that explicitly.

## Step Definition Design



- keep transformation logic and selectors out of the scenario text

- avoid huge reusable "god steps" that hide multiple behaviors

- map steps to page objects, domain services, or API helpers only as implementation details

- treat duplicate step wording with different hidden behavior as a smell

## Tooling Notes from Primary Sources


### Cucumber

Cucumber frames executable specifications as plain-text scenarios that are bound to code. It is strongest when scenario text remains readable to the broader team. Sources: Cucumber BDD docs.  
<https://cucumber.io/docs/bdd/>  
<https://cucumber.io/docs/gherkin/>

### Reqnroll (.NET)

Reqnroll is an open-source .NET BDD framework that uses Gherkin and supports NUnit, xUnit-compatible ecosystems through template options, and dry-run validation. Reqnroll documents that users can install project templates with `dotnet new install Reqnroll.Templates.DotNet` and create a project with `dotnet new reqnroll-project`. Sources: Reqnroll documentation and FAQ.  
<https://docs.reqnroll.net/latest/installation/setup-project.html>  
<https://docs.reqnroll.net/latest/guides/how-to-configure-build.html>  
<https://docs.reqnroll.net/latest/faq.html>

The FAQ notes that the SpecFlow OSS repository was removed in December 2024 and positions Reqnroll as the maintained open-source continuation for the .NET ecosystem.  
<https://docs.reqnroll.net/latest/faq.html>

### Dry-run validation

Reqnroll documents a dry-run mode for validating Gherkin and binding coverage in CI before executing full automation.  
<https://docs.reqnroll.net/latest/execution/dry-run.html>

## Common Failure Modes



- **Scenario as script**: describing every click rather than the behavior.

- **Scenario as unit test**: encoding low-level implementation branches that are clearer in ordinary code tests.

- **Ambiguous vocabulary**: "valid", "approved", or "processed" without a domain definition.

- **Automation-first BDD**: step code and framework choices appearing before example conversations.

- **Overgrown background blocks**: too much hidden context makes each scenario hard to understand.

## Review Checklist



- Does each scenario communicate a rule that matters to multiple roles?

- Could the same behavior be verified faster at a lower level without losing communication value?

- Are steps using domain language instead of selectors or method names?

- Are examples chosen to illuminate boundaries and exceptions?

- Is there duplication that should become a rule table or a lower-level test instead?

## Suggested Book and Community References



- Dan North, original BDD articles and talks

- Gojko Adzic, *Specification by Example*

- David Chelimsky et al., *The RSpec Book*
