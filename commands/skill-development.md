# Planguage skill development loop

Run the coordinated development loop for the Planguage skill family.

- Inspect the source requirement material before editing any skill text.
- Keep the four-role split clear:
  - `planguage-author` for requirement drafting
  - `planguage-reader` for interpretation and review
  - `planguage-implementor` for delivery planning
  - `planguage-tester` for acceptance evidence
- Keep repo-level assets aligned:
  - `agents/planguage-maintainer.md`
  - `commands/claude-command-sdlc.md`
  - `commands/claude-hook-sdlc.md`
  - `commands/claude-agent-sdlc.md`
- Run:
  - `python scripts/lint_skills.py planguage-author planguage-reader planguage-implementor planguage-tester`
  - `python scripts/validate_skills.py planguage-author planguage-reader planguage-implementor planguage-tester`
  - `python scripts/skill_affordance_report.py planguage-author planguage-reader planguage-implementor planguage-tester`
- Finish with repository checks:
  - `make test`
  - `make build`
  - `make verify`
