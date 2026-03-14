# llm-software-design

A cross-compatible repository of 105 LLM skills for software design guidance, language-specific code review, and source-level API documentation. The merged catalog now includes the original design-review skills, 50 `[language]-best-practice` skills, and 50 `[language]-docstrings` skills that align on consistent structure and depth.

## Skill Families

### Design and review skills

| Skill | Description |
| --- | --- |
| `solid` | Apply SOLID principles to class design, dependency direction, and refactoring tradeoffs |
| `oop` | Reason about object modeling, responsibilities, collaboration, and boundary placement |
| `design-patterns` | Choose and critique common patterns and the tradeoffs that justify them |
| `software-architecture` | Compare architectural styles, seams, integration choices, and system-level tradeoffs |
| `code-smells` | Identify maintainability risks, triage them, and propose pragmatic refactoring paths |

### Language best-practice skills

The repository ships 50 generated `[language]-best-practice` skills for idiomatic review guidance, maintainability checks, and ecosystem-standard tooling choices.

See [docs/language-best-practice-skills.md](docs/language-best-practice-skills.md) for the full catalog.

### Docstring skills

The repository also ships 50 generated `[language]-docstrings` skills that guide an agent toward the most widely accepted source-adjacent documentation convention for each language and explain how external tools consume that embedded documentation.

See [docs/docstring-skills.md](docs/docstring-skills.md) for the full catalog.

### Cross-family language matrix

See [docs/language-skill-matrix.md](docs/language-skill-matrix.md) to align each ranked language across the best-practice and docstring skill families.

## Installation

See [INSTALL.md](INSTALL.md) for full setup guidance.

## Development

```bash
make lint
make test
make build
make verify
```

The Python helpers are also available directly:

```bash
python scripts/lint_skills.py
python scripts/validate_skills.py
python -m unittest discover -s tests -v
```

Build artifacts land in `built/` as one ZIP per skill. Each archive is rooted at `llm-software-design/skills/<skill>/...` so release uploads match the repo layout.

Legacy `linting/` and `validation/` shell entrypoints remain available as compatibility wrappers for one release cycle, but they now delegate to the Python baseline.

## Structure

```text
llm-software-design/
├── .claude-plugin/
├── .github/workflows/
├── docs/
├── linting/
├── scripts/
├── skills/
├── tests/
├── validation/
├── AGENTS.md
├── CHANGELOG.md
├── INSTALL.md
├── Makefile
└── README.md
```

## Design intent

These skills are for informing implementation work, design reviews, migration planning, language-specific code cleanup, and source documentation tasks. They should guide the agent toward better boundaries, naming, abstractions, dependency direction, tradeoff analysis, and externally consumable API documentation rather than prescribe one framework or language.

## License

[MIT](LICENSE.md)
