# Claude command SDLC for Planguage

Use this loop when updating command files that orchestrate the Planguage skill family.

- Read the affected command markdown and the matching skill or agent files first.
- Keep command docs short, imperative, and runnable.
- Prefer explicit target skill names over vague family references.
- Keep validation commands current with the new Planguage skills.
- Re-check:
  - `commands/skill-development.md`
  - `commands/quality-gate.md`
  - `commands/affordance-audit.md`
  - `agents/planguage-maintainer.md`
- Validate with:
  - `markdownlint-cli2 commands/*.md`
  - `python scripts/lint_skills.py planguage-author planguage-reader planguage-implementor planguage-tester`
