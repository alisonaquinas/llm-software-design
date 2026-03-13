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
bash linting/lint-all.sh
bash validation/validate-skill.sh skills/solid
```

## Structure

```text
llm-software-design/
├── .claude-plugin/
├── .github/workflows/
├── docs/
├── linting/
├── skills/
├── validation/
├── AGENTS.md
├── CHANGELOG.md
├── INSTALL.md
└── README.md
```

## Design Intent

These skills are for informing implementation work, design reviews, and planning conversations. They should guide the agent toward better boundaries, naming, abstractions, dependencies, and tradeoff analysis rather than prescribe one framework or language.

## License

[MIT](LICENSE.md)
