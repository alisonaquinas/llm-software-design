# Scenario Patterns

Use this reference to build a balanced scenario matrix for a target skill.
Choose the smallest set that still exercises the skill's promises on live work.

---

## Minimum Coverage

Build at least five scenarios. Cover each of these before adding extras:

1. **Happy path** — the main workflow shown in the target skill's Quick Start
2. **Variant** — same workflow with one meaningful change in input, flag, or size
3. **Verification** — explicit check that proves the result is correct
4. **Recovery** — one likely failure or misstep with a recovery attempt
5. **Setup** — dependency, fixture, bootstrap, or environment assumption

Add up to five more when the skill claims broader coverage.

## Optional Expansion Buckets

Use these only after the minimum coverage is present:

- **Safety** — destructive or write-heavy workflow exercised with safe guards
- **Integration** — target skill paired with another nearby skill or common tool
- **Scale** — slightly larger fixture or repeated operation
- **Format drift** — alternate input format, malformed input, or missing field
- **Documentation discovery** — test whether the right guidance is easy to find

## Scenario Generation Method

1. Read the target skill description and list every promised workflow.
2. Mark which promises are common, risky, or likely to fail in practice.
3. Convert the top promises into scenarios with live actions and success checks.
4. Prefer fixtures that take less than a minute to create and verify.
5. Replace any scenario that duplicates evidence already gathered.

## Good Scenario Shape

Each scenario should answer five questions:

- What job is being attempted?
- Which part of the skill should enable it?
- What live action proves the attempt happened?
- What observable check proves success or failure?
- What would make the skill easier to use next time?

## Scenario Sources

Pull scenarios from these parts of the target skill in this order:

1. Quick Start workflows
2. Safety rules and warnings
3. Examples in `SKILL.md`
4. Reference files linked in the Intent Router
5. Scripts or assets the skill says to use

## Replacement Rules

If a scenario is blocked:

1. Record the blocker with the exact missing precondition.
2. Preserve the failed attempt in the evidence table.
3. Add a replacement scenario from an uncovered bucket.
4. Keep the total at five or more attempted scenarios.
