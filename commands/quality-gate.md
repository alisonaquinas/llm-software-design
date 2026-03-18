# Software design quality gate

Run the software design quality loop for `llm-software-design`.

- For a single skill:
  - `python scripts/lint_skills.py <skill-name>`
  - `python scripts/validate_skills.py <skill-name>`
  - `python scripts/skill_affordance_report.py <skill-name>`
- For repository-wide checks:
  - `make test`
  - `make build`
  - `make verify`
