# Affordance-focused design review

Run a targeted review flow for design skills with affordance focus.

- Review impacted skill families in `docs/language-skill-matrix.md` and `docs/language-best-practice-skills.md`.
- Run:
  - `python scripts/skill_affordance_report.py <skill-name>`
  - `python scripts/lint_skills.py <skill-name>`
  - `python scripts/validate_skills.py <skill-name>`
- Finish with repository checks:
  - `make test`
  - `make verify`
