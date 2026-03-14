# Report Template

Use this template for the final skill test-drive report.
Keep the writing evidence-first and tie every recommendation to scenario IDs.

---

## Summary

- **Target skill:** `<skill-name>`
- **Scenarios attempted:** `<count>`
- **Outcome mix:** `<passes / partials / fails / blocked>`
- **Final verdict:** `approve` / `revise` / `re-test`

## Scenario Outcomes

| ID | Bucket | Outcome | Score | Key evidence |
|---|---|---|---|---|
| S01 | happy-path | PASS | 11 | Quick Start example worked as written |
| S02 | variant | PARTIAL | 8 | Missing flag for alternate input shape |
| S03 | verification | FAIL | 5 | No reliable success check was documented |

## Strengths

- `<strength tied to one or more scenario IDs>`
- `<strength tied to one or more scenario IDs>`

## Issues by Priority

### High

- `<issue>` — evidence: `Sxx`, `Syy`; recommended fix: `<change>`

### Medium

- `<issue>` — evidence: `Sxx`; recommended fix: `<change>`

### Low

- `<issue>` — evidence: `Sxx`; recommended fix: `<change>`

## Improvement Actions

1. `<highest leverage change>`
2. `<next change>`
3. `<optional follow-up>`

## Notes

- Record blocked scenarios and exact blockers here.
- Call out repeated ambiguity or repeated recovery failures here.
- Note any temporary installs, fixtures, or disposable repos created during the run.
