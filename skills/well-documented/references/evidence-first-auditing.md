# Evidence-First Documentation Auditing

A documentation audit should answer two different questions:

1. **Can a reader find the right document?**
2. **Can the reader trust that document right now?**

The original structure-first checks are still useful, but they are only the opening pass. Evidence-first auditing adds signals for truth, freshness, and drift.

## Priority order

When auditing, prefer this order of concern:

1. broken links or references to files that do not exist
2. local command snippets that point to missing scripts or missing Make targets
3. code changes without any corresponding documentation updates
4. bootstrap markers or placeholder text that survived into finished docs
5. missing but helpful documentation files

That ordering keeps the audit focused on operational trust before coverage.

## What counts as evidence

Useful evidence includes:

- relative links that resolve from the file where they appear
- backticked file paths in docs that map to real repository paths
- command examples that reference real local scripts, entrypoints, or Make targets
- diagrams and layout sections that still match current names
- git working-tree changes that show code and docs moving together
- absence of `BOOTSTRAP` markers in content that is supposed to be final

## What the shell audit can prove safely

The bundled shell audit is intentionally conservative. It can safely verify:

- whether expected docs exist
- whether markdown links resolve
- whether common local command patterns reference real files or Make targets
- whether bootstrap markers remain in live docs or source headers
- whether there are current code changes without any documentation changes in the working tree

It cannot fully prove semantic correctness. Use judgment and spot-check the code whenever the stakes are high.

## Manual spot checks still matter

After the scripted pass, manually sample a few changed areas and ask:

- does the README still describe the actual install and usage path?
- does AGENTS.md still reflect the real folder layout and invariants?
- do headers or docstrings describe current behavior rather than intended future behavior?
- are diagrams still naming the right components and boundaries?
- is the documentation actionable for the next change, not just present?

## When to tighten the audit

Use stricter evidence checks when:

- the repository is shipped to external users
- an agent will make broad edits based on the docs
- the project has multiple maintainers or frequent ownership changes
- the code is regulated, safety-critical, or operationally sensitive
- the user reports that docs have become untrustworthy or stale

## Recommended audit phrasing

When you report findings, make the distinction explicit:

- **coverage gap** — a useful document is missing
- **truth gap** — a document exists but points to something that is wrong or gone
- **freshness gap** — code changed without the docs that explain it
- **bootstrap gap** — auto-generated placeholder text still needs review

That framing makes remediation much easier to prioritize.
