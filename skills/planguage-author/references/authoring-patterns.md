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
