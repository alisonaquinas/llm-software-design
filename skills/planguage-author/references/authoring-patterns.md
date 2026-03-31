# Planguage authoring patterns

## Core fields

- `Tag`: one stable identifier for one requirement object
- `Gist` or `Ambition`: the reason the requirement exists
- `Scale`: what is measured, in what units, and under which conditions
- `Meter`: how the evidence will be collected
- `Goal`: the committed target level
- `Fail`: the unacceptable level
- `Stretch` and `Wish`: optional higher ambitions when they affect tradeoffs

## Authoring sequence

1. extract the desired future outcome
2. split out hidden design ideas, assumptions, and stakeholder rationale
3. name the requirement with one reusable tag
4. define scale and meter before finalizing targets
5. set the target ladder
6. record source, owner, and open questions

## Good patterns

- one tag per measurable concern
- explicit units and conditions
- meter wording that can be repeated by test or operations teams
- fail and goal levels that make tradeoffs visible
- open questions listed separately from the committed requirement

## Anti-patterns

- vague adjectives such as `fast`, `secure`, or `user-friendly`
- hidden design commitments such as mandated algorithms or frameworks
- multiple outcomes bundled into one tag
- scale without a meter
- targets copied from another system without source or context
- fake precision from weak source text, such as inventing numeric goals from adjectives alone

## Insufficient evidence

Stop before setting committed fail or goal levels when the source only provides:

- adjectives without measurable thresholds
- stakeholder wishes without a test method
- open questions about scope, user class, workload, or environment
- copied targets with no local source, rationale, or benchmark

In that state, it is still safe to produce:

- `Tag`
- `Gist` or `Ambition`
- a provisional `Scale`
- a provisional or to-be-defined `Meter`
- `Stakeholders`
- `Source`
- explicit `Open questions`

Surface follow-up questions that would unlock real targets, such as:

- which population, workload, or environment does the requirement apply to?
- what evidence source should define the target: benchmark, regulation, stakeholder commitment, or historical baseline?
- what exact result would count as fail versus acceptable success?
- who owns the decision to commit the target?

## Safe partial requirement example

```text
Tag: Search.Results.Relevance
Gist: Return relevant results for common customer queries.
Ambition: Relevant results reduce reformulation effort and improve product discovery.
Scale: Percentage of top-10 search results judged relevant for representative catalog queries.
Meter: To be defined after the benchmark query set and reviewer rubric are agreed.
Stakeholders: Customers, Merchandising, Search Team.
Source: Product note stating search should be "more relevant".
Open questions:
- which query set defines representative customer searches?
- who scores relevance and with what rubric?
- what precision level is required for release versus stretch?
```

## Starter template

```text
Tag:
Gist:
Ambition:
Scale:
Meter:
Past:
Current:
Fail:
Goal:
Stretch:
Wish:
Stakeholders:
Owner:
Source:
```
