# Evaluation Rubric

Use this rubric to turn live scenario evidence into consistent feedback.
Apply it after each scenario and again when writing the final summary.

---

## Outcome Labels

| Label | Meaning |
|---|---|
| `PASS` | The target skill enabled the scenario cleanly and verification succeeded |
| `PARTIAL` | The scenario completed, but the skill omitted, obscured, or weakened key guidance |
| `FAIL` | The scenario did not complete because the skill guidance was wrong, incomplete, or unsafe |
| `BLOCKED` | A real attempt was made, but an external blocker prevented completion |

## Scoring Dimensions

Score each scenario from 0–2 on the following dimensions:

| Dimension | 0 | 1 | 2 |
|---|---|---|---|
| Discoverability | Relevant guidance was hard to find | Guidance was findable but scattered | Guidance was easy to find quickly |
| Completeness | Key steps were missing | Most steps present, some gaps | Steps were complete and ordered |
| Correctness | Instructions were wrong or misleading | Minor correction needed | Instructions worked as written |
| Verification | No clear success check | Weak or partial success check | Clear and reliable verification |
| Safety | Unsafe default or missing guardrail | Some guardrails, still incomplete | Safe default and recovery guidance |
| Efficiency | Excessive extra work required | Some avoidable extra work | Minimal friction for common work |

## Interpreting Total Scores

| Total | Interpretation |
|---|---|
| 10–12 | Strong scenario support |
| 7–9 | Usable but needs refinement |
| 4–6 | Significant usability gaps |
| 0–3 | Fundamental rework needed |

## Turning Scores into Feedback

- Low discoverability usually means the description, Quick Start, or Intent Router needs work.
- Low completeness usually means examples or workflow steps are missing.
- Low correctness usually means the commands, file paths, or assumptions are wrong.
- Low verification usually means expected output or success checks are not documented.
- Low safety usually means safer defaults, warnings, or recovery steps are missing.
- Low efficiency usually means the common path is too verbose for the value delivered.

## Escalation Rules

Escalate an issue to the final summary when any of these are true:

- The same issue appears in two or more scenarios
- A safety or correctness problem caused a `FAIL`
- A blocker exposed a hidden dependency the skill never mentioned
- A common workflow scored below 7 total points

## Recommended Final Verdicts

- **approve** — most scenarios pass; no repeated safety or correctness issues
- **revise** — the skill is promising, but the report shows clear fixable gaps
- **re-test** — changes were made after the first run, so another live pass is needed
