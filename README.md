# llm-software-design

A cross-compatible repository of LLM skills for software design guidance. The collection focuses on object-oriented design, architecture decisions, maintainability, and design-quality review patterns that help the agent reason before coding.

## Initial Skill Set

| Skill | Description |
| --- | --- |
| `solid` | Apply SOLID principles to code and design discussions |
| `oop` | Reason about object-oriented modeling, responsibilities, and collaboration |
| `design-patterns` | Choose and critique common design patterns and their tradeoffs |
| `software-architecture` | Compare architectural styles, boundaries, and system design tradeoffs |
| `code-smells` | Identify maintainability risks and propose refactoring directions |

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

Build artifacts land in `built/` as one ZIP per skill. Each archive is rooted at
`llm-software-design/skills/<skill>/...` so release uploads match the repo layout.

Legacy `linting/` and `validation/` shell entrypoints remain available as
compatibility wrappers for one release cycle, but they now delegate to the
Python baseline.

## Structure

```text
llm-software-design/
├── .claude-plugin/
├── .github/workflows/
├── built/
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

## Design Intent

These skills are for informing implementation work, design reviews, and planning conversations. They should guide the agent toward better boundaries, naming, abstractions, dependencies, and tradeoff analysis rather than prescribe one framework or language.

## License

[MIT](LICENSE.md)
