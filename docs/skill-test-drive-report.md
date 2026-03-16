# Skill Test-Drive Report

This report records the repository-wide test-drive pass used to tighten the skills after the catalog already passed structural linting and pre-flight validation.

## Scope

- 114 skills total
- 50 `[language]-best-practice` skills
- 50 `[language]-docstrings` skills
- 14 design, methodology, and documentation skills

## Test-Drive Method

The pass followed the attached `skill-test-drive` and `skill-development` guidance:

1. inspect the skill promises in frontmatter, Quick Start, references, and examples
2. exercise representative requests from each family
3. record friction around discovery, completeness, correctness, verification, safety, and efficiency
4. apply the smallest repository-wide fixes that improve the common path without bloating the skills
5. re-run linting, validation, and unit tests after the edits

## Scenario Matrix

| ID | Bucket | Target surface | Live question used during review | What counted as success |
| --- | --- | --- | --- | --- |
| S01 | happy-path | best-practice family | review a language module for idiomatic structure and test gaps | the skill makes the review path obvious without loading many extra files |
| S02 | variant | docstring family | add or normalize machine-readable docs while preserving an existing style | the skill explains when to keep the current convention instead of rewriting everything |
| S03 | verification | all families | confirm how the result should be checked after edits | the skill names a concrete verification path instead of ending at advice only |
| S04 | recovery | all families | resolve missing context, mixed styles, or competing conventions | the skill gives a safe fallback and states what fact would narrow the recommendation |
| S05 | setup | well-documented | choose between audit, normalize, init, headers, docstrings, and concept checks | the command-selection path is clear before any broad write action |

## Findings

### What was already strong

- the catalog already had consistent frontmatter, intent routers, and safety sections
- generated language skills already had enough inline examples to pass the validation gate
- the design and methodology skills already had solid domain-specific references

### Friction found during the test drive

- many skills ended at advice without an explicit verification or follow-through section
- generated language skills did not consistently say how to recover when repository conventions overrode the default guidance
- the `well-documented` skill had the highest usability friction: missing Quick Start, noisy formatting, and a weaker command-selection path than the rest of the catalog
- future maintenance lacked a fast way to audit these affordances across the whole repository

## Improvements Applied

### Repository-wide

- added a verification-focused section to every skill so the common path now answers "how should the result be checked?"
- added recovery guidance to the generated language skills so they preserve project-local conventions more explicitly
- added targeted next-step guidance to the design and methodology skills so recommendations stay testable and reversible

### `well-documented`

- rewrote the skill for a cleaner operational flow
- added a Quick Start section
- added command-selection guidance so the agent can choose the smallest safe operation first
- tightened safety notes around large write operations and template misuse
- removed noisy formatting and misleading references to absent test paths

### Maintenance support

- added `scripts/skill_affordance_report.py` to summarize key affordances across the catalog
- added `tests/test_skill_affordances.py` so Quick Start, Verification, and Safety sections remain enforced by the test suite

## Re-Test Summary

After the edits:

- every skill now exposes Quick Start, Verification, and Safety sections
- the generated families now make their default-vs-local-convention recovery path explicit
- the `well-documented` skill now matches the operational clarity of the rest of the catalog

## Suggested Future Test-Drive Focus

A later pass should spend deeper live time on:

- higher-fidelity language examples for the least-common language pairs
- multi-skill workflows that chain `well-documented`, docstring, and best-practice skills together
- additional design-methodology scenarios that compare overlapping choices such as `ddd` vs `software-architecture` and `idd` vs `dependency-injection`

## Well-Documented Follow-Up Test Drive

A focused second pass on `well-documented` exposed three practical issues in live use: freshly bootstrapped READMEs linked to license files that did not exist yet, `add-file-headers.sh` dropped executable bits on rewritten shell scripts, and quiet-mode audit scores under-counted PASS items. The fix set removed the broken default license links, made bootstrap notes explicit in the README and agent templates, preserved file permissions during header insertion, and corrected quiet-mode scoring so the audit summary remains truthful. The bash harness for `well-documented` was also refreshed to match the maturity-level model and the current audit semantics.
