# llm-software-design

A cross-compatible repository of 120 LLM skills for software design guidance, language-specific code review, and source-level API documentation. The merged catalog now includes 9 design-review skills, 7 design methodology skills, 4 requirements and specification skills, 50 `[language]-best-practice` skills, and 50 `[language]-docstrings` skills that align on consistent structure and depth.

## Skill Families

### Design and review skills

| Skill | Description |
| --- | --- |
| `solid` | Apply SOLID principles to class design, dependency direction, and refactoring tradeoffs |
| `oop` | Reason about object modeling, responsibilities, collaboration, and boundary placement |
| `design-patterns` | Choose and critique common patterns and the tradeoffs that justify them |
| `software-architecture` | Compare architectural styles, seams, integration choices, and system-level tradeoffs |
| `code-smells` | Identify maintainability risks, triage them, and propose pragmatic refactoring paths |
| `high-coherence` | Maintain conceptual integrity across boundaries, dependency rules, and runtime behavior |
| `low-coupling` | Reduce structural and operational coupling to improve change locality and lower blast radius |
| `semantic-versioning` | Apply SemVer 2.0.0, choose the correct bump level, and manage git tags with `bump-version` / `set-version` |
| `well-documented` | Audit, initialize, and normalize repository documentation: README, AGENTS.md, CONCEPTS.md, file headers, and docstrings |

### Design methodology skills

| Skill | Description |
| --- | --- |
| `bdd` | Specify behavior through collaborative examples, executable scenarios, and shared language |
| `tdd` | Drive design with test-first development, fast feedback loops, and small refactoring steps |
| `ddd` | Model complex business domains using bounded contexts, ubiquitous language, and aggregates |
| `dependency-injection` | Design, review, and refactor explicit dependency graphs, composition roots, and service lifetimes |
| `event-sourcing` | Design systems that persist state as ordered domain events and derive views through replay |
| `idd` | Design systems around stable contracts, ports, and interface boundaries |
| `pdd` | Design asynchronous software around promises, tasks, futures, and structured concurrency |

### Requirements and specification skills

| Skill | Description |
| --- | --- |
| `planguage-author` | Author measurable Planguage functional and quality requirements |
| `planguage-reader` | Interpret, review, and translate Planguage requirements |
| `planguage-implementor` | Turn Planguage requirements into delivery plans and traceable implementation slices |
| `planguage-tester` | Derive acceptance tests and audit evidence from Planguage requirements |

### Language best-practice skills

The repository ships 50 generated `[language]-best-practice` skills for idiomatic review guidance, maintainability checks, and ecosystem-standard tooling choices.

See [docs/language-best-practice-skills.md](docs/language-best-practice-skills.md) for the full catalog.

### Docstring skills

The repository also ships 50 generated `[language]-docstrings` skills that guide an agent toward the most widely accepted source-adjacent documentation convention for each language and explain how external tools consume that embedded documentation.

See [docs/docstring-skills.md](docs/docstring-skills.md) for the full catalog.

### Cross-family language matrix

See [docs/language-skill-matrix.md](docs/language-skill-matrix.md) to align each ranked language across the best-practice and docstring skill families.

See [docs/skill-test-drive-report.md](docs/skill-test-drive-report.md) for the latest repository-wide test-drive findings and the improvements that came out of that pass.

## Installation

See [INSTALL.md](INSTALL.md) for full setup guidance.

## Development

\`\`\`bash
make lint
make test
make build
make verify
\`\`\`

The Python helpers are also available directly:

\`\`\`bash
python scripts/lint_skills.py
python scripts/validate_skills.py
python -m unittest discover -s tests -v
\`\`\`

Build artifacts land in \`built/\` as one ZIP per skill. Each archive is rooted at \`llm-software-design/skills/<skill>/...\` so release uploads match the repo layout.

Legacy \`linting/\` and \`validation/\` shell entrypoints remain available as compatibility wrappers for one release cycle, but they now delegate to the Python baseline.

## Structure

\`\`\`text
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
\`\`\`

## Design intent

These skills are for informing implementation work, design reviews, migration planning, language-specific code cleanup, and source documentation tasks. They should guide the agent toward better boundaries, naming, abstractions, dependency direction, tradeoff analysis, and externally consumable API documentation rather than prescribe one framework or language.

## License

[MIT](LICENSE.md)
