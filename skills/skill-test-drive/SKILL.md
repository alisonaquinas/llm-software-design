---
name: skill-test-drive
description: >
  Test-drive a skill by designing live scenarios, executing them with the target
  skill's own guidance, and reporting how well the skill enabled the work. Use when reviewing a skill after linting, gathering evidence for usability,
  checking whether examples and references are sufficient, or finding missing
  guidance before release. Best for skills that can be exercised safely in a
  temporary workspace. Run 5–10 realistic scenarios that cover common tasks,
  edge cases, recovery paths, and verification. Create temporary files or
  install small disposable utilities if needed, record outcomes and friction,
  and turn the evidence into concrete improvement recommendations. Pair with
  skill-linting for structural checks, skill-validation for release scoring,
  and skill-creator for implementing fixes.
---

# Skill Test Drive

Exercise a target skill on real work instead of reviewing it only as text.
Design a compact scenario matrix, execute the scenarios in a disposable
workspace, and convert the results into concrete feedback about clarity,
coverage, safety, and reliability.

## Intent Router

- `references/scenario-patterns.md` — Scenario buckets, coverage rules, and
  generation method; load while designing the 5–10 scenario matrix.
- `references/evaluation-rubric.md` — Execution scoring dimensions and issue
  taxonomy; load while rating outcomes and writing improvement feedback.
- `references/report-template.md` — Final report structure and evidence table;
  load when producing the deliverable.

## Quick Start

1. Lint the target skill first. Fix structural FAIL items before test-driving.
2. Read the target skill's frontmatter, Quick Start, Safety Rules, references,
   and scripts.
3. Build a 5–10 scenario matrix from the promises the skill makes.
4. Execute each scenario in a temporary workspace with real commands, files,
   and verification checks.
5. Record whether the skill enabled the work cleanly, partially, or poorly.
6. Report the strongest patterns, the sharpest failure modes, and the highest
   leverage fixes.

Create a disposable workspace before the first scenario. The cleanup trap below removes only the temporary directory created by `mktemp`; do not reuse it for non-disposable data:

```bash
workdir="$(mktemp -d)"
# Warning: remove only the disposable mktemp directory created above.
trap 'rm -rf "$workdir"' EXIT
mkdir -p "$workdir/fixtures" "$workdir/output"
printf 'alpha\nbeta\ngamma\n' > "$workdir/fixtures/sample.txt"
```

Seed the scenario matrix before execution:

```markdown
| ID | Goal | Bucket | Live action | Success signal |
|---|---|---|---|---|
| S01 | Exercise the most common workflow | happy-path | Run the main command or file flow | Output matches the skill example |
| S02 | Exercise a realistic variant | variant | Change one meaningful input or flag | Variant still succeeds safely |
| S03 | Exercise verification | verification | Perform the skill's stated check | Verification confirms the result |
| S04 | Exercise recovery | recovery | Trigger one likely failure mode | Recovery guidance works |
| S05 | Exercise setup or dependency handling | setup | Install or prepare what the skill assumes | Preconditions become explicit |
```

## Scenario Design Rules

1. Derive scenarios from what the target skill claims to support, not from an
   unrelated wishlist.
2. Cover at least five scenarios. Target seven. Expand to ten only when the
   skill has broad surface area.
3. Include the following buckets before repeating any bucket:
   - happy path
   - realistic variant
   - verification or inspection
   - recovery from one likely error
   - setup, environment, or dependency handling
4. Add safety scenarios whenever the skill mentions writes, deletes, network
   calls, overwrites, or privileged operations.
5. Prefer small live fixtures over synthetic prose-only review. Create files,
   directories, inputs, or disposable repos as needed.
6. If a claimed dependency is missing, install it only when the install is
   small, reversible, and safe in the current environment.
7. If a scenario is blocked by permissions, network limits, or unavailable
   tooling, document the blocker and replace it so the run still reaches at
   least five attempted scenarios.

## Execution Workflow

For each scenario, follow this sequence:

1. Name the scenario and state the success condition.
2. Identify the exact part of the target skill that should enable the work.
3. Execute the task with live commands, inputs, and outputs.
4. Verify the result using the target skill's own verification guidance when
   available.
5. Score the outcome as `PASS`, `PARTIAL`, `FAIL`, or `BLOCKED`.
6. Capture friction with short evidence notes.
7. Map each issue to an improvement category.

Use a per-scenario log like this:

```markdown
### S03 — Verify transformed output
- Target promise: quick-start example says the result can be checked with `cat output.txt`
- Live action: ran the transformation on a disposable fixture in `$workdir`
- Verification: output file existed, but newline handling differed from the example
- Outcome: PARTIAL
- Friction: example omitted the flag needed for stable newline handling
- Improvement: add a second example and expected output block
```

## Evaluation Rules

- Count only live attempts. Reading the skill without executing work does not
  satisfy a scenario.
- Require at least three scenarios that perform actual commands or file
  operations.
- Count `BLOCKED` only after a genuine attempt and a documented blocker.
- Treat repeated confusion as a signal. If the same ambiguity appears in two or
  more scenarios, elevate it in the final report.
- Prefer evidence over opinion. Tie every recommendation to a scenario result,
  an observed failure mode, or avoidable extra work.

## Safety Rules

- Use disposable workspaces and fixtures by default.
- Prefer read-only, dry-run, or local-only variants when the target skill
  mentions destructive operations.
- Do not mutate user data, production systems, or long-lived repositories.
- Install only small, low-risk utilities when they are needed to exercise the
  skill's advertised workflow.
- Stop a scenario immediately if continuing would require unsafe privileges or
  non-disposable data.
- Clean up temporary artifacts after capturing enough evidence for the report.

## Issue Categories

Classify each problem under one primary category:

- **routing** — description or trigger language failed to route the skill
- **coverage** — promised workflow missing or incomplete
- **clarity** — steps ambiguous, out of order, or hard to follow
- **example-quality** — examples too thin, unrealistic, or unverifiable
- **safety** — risky action lacks guardrails, safer default, or recovery path
- **environment** — hidden dependency, install gap, or platform assumption
- **verification** — no clear success check or expected output
- **efficiency** — too many unnecessary steps to complete common work

Load `references/evaluation-rubric.md` when a scenario needs deeper scoring or
when multiple issue categories overlap.

## Final Deliverable

Load `references/report-template.md` and produce a concise report with:

1. Scenario matrix and outcome summary
2. Strongest evidence that the skill works well
3. Highest-severity issues with scenario IDs
4. Concrete improvement actions ordered by leverage
5. Recommended next step: `approve`, `revise`, or `re-test`

## Handoff to Related Skills

- Run `skill-linting` first to clear structural failures.
- Use this skill to gather live evidence for real usability.
- Run `skill-validation` after the test drive and use the findings to score V07
  and to sharpen V03–V05 judgments.
- Use `skill-creator` to implement the improvements surfaced by the report.
