# Repository Documentation Structure Standard

## Required files at every level

### Root of the repository

| File | Audience | Required | Purpose |
| --- | --- | --- | --- |

| `README.md` | Humans | Yes | Project overview, install, usage, contributing |
| `AGENTS.md` | AI agents | Yes | Repo layout, workflows, invariants, modification rules |
| `CLAUDE.md` | Claude Code | Yes | Stub pointing to `AGENTS.md`; place Claude-specific overrides here |
| `CONCEPTS.md` | Humans + AI | Yes | Glossary of domain concepts with cross-references |

| `CHANGELOG.md` | Humans | Yes | Release history (Keep a Changelog format) |
| `docs/` | Humans | Recommended | Design documents, architecture, ADRs, diagrams |

### Every directory containing source files (recursive)

| File | Audience | Required | Purpose |
| --- | --- | --- | --- |

| `README.md` | Humans | Yes | What lives here, why, how to use it |
| `AGENTS.md` | AI agents | Yes | Directory layout, modification rules, invariants, cross-references |
| `CLAUDE.md` | Claude Code | Yes | Stub or symlink to `AGENTS.md` in same directory |

Exceptions (no folder docs required):

- Auto-generated directories: `node_modules/`, `vendor/`, `.venv/`, `__pycache__/`, `dist/`, `out/`, `build/`

- Version-control internals: `.git/`

- Pure asset directories with no logic: `assets/`, `images/`, `icons/` (README still recommended)

---


## docs/ folder structure

The `docs/` folder holds long-form design and reference documentation intended for human readers. It should be organized around the project's major concerns, not its code structure.

### Recommended layout

```text
docs/
├── README.md              # index of all docs in this folder
├── architecture.md        # system-level architecture overview
├── design/                # detailed design documents
│   ├── README.md
│   ├── <feature>.md
│   └── decisions/         # Architecture Decision Records (ADRs)
│       ├── README.md
│       └── 0001-<title>.md
└── api/                   # public API reference (if not auto-generated)
    └── README.md
```text

### Diagrams in human-centered documents

**PlantUML is the preferred diagramming tool** for embedding visual structure in `README.md`, `docs/` files, and any human-centered documentation.

Use PlantUML for:

- Class and object diagrams (OOP structure)

- Sequence diagrams (interactions, workflows)

- Component and deployment diagrams (architecture)

- Activity and state diagrams (process flows)

- Use-case diagrams (user interactions)

- Mind maps (concept relationships)

Embed as fenced code blocks:

````markdown

```plantuml
@startuml
<diagram content>
@enduml
```text

````

Or generate `.svg`/`.png` outputs and reference them as images.

PlantUML diagrams must be kept in sync with the code they describe. When a diagram references class names, method names, or component names that change in code, update the diagram in the same commit.

Do not use PlantUML in `AGENTS.md` files — AI agents read those as plain text. Use ASCII art or table-based diagrams in `AGENTS.md` instead.

---


## README.md standard sections

A complete human-centered `README.md` contains:

1. **Title** — project name as `# Heading`

2. **One-line description** — what it does, for whom

3. **Badges** (optional) — CI status, version, license

4. **Table of contents** (for files longer than ~150 lines)

5. **Overview / Architecture** — 2–4 paragraphs; include a PlantUML diagram when structure is non-trivial

6. **Prerequisites** — system requirements, required tools

7. **Installation** — exact steps to set up

8. **Usage** — concrete examples; command-line invocations or code snippets

9. **Configuration** — environment variables, config files, options

10. **Development** — how to set up a dev environment, run tests, lint

11. **Contributing** — branch strategy, PR process, code style expectations

12. **License** — one-liner referencing `LICENSE.md` or the SPDX identifier

Missing sections are a `WARN` during `audit-docs`, not a `FAIL`, unless the section is essential for the project type.

---


## AGENTS.md standard sections

A complete AI-agent-centered `AGENTS.md` contains:

1. **What this is** — one sentence.

2. **Layout** — ASCII tree or table of files and directories, each with a one-line description.

3. **Workflows** — step-by-step procedures for the most common modification tasks.

4. **Invariants** — explicit "Do Not Violate" list of structural or semantic rules.

5. **Cross-references** — links to parent, sibling, and child `AGENTS.md` files; any globally relevant docs.

Cross-reference format at depth > 0:

```markdown
## See Also


- [Parent AGENTS.md](../AGENTS.md)

- [Root AGENTS.md](../../AGENTS.md)

- [Sibling module AGENTS.md](../sibling/AGENTS.md)

```text

---


## CONCEPTS.md standard structure

```markdown
# Concepts

## <Concept Name>

<One paragraph of prose: what it is, why it matters, how it fits into the project.>

**See also:** [path/to/related.md](path/to/related.md), [`$skill-name`], [Other Concept](#other-concept)

```text

Rules:

- Each concept gets exactly one paragraph (3–7 sentences).

- "See also" line uses relative paths for local files, backtick-prefixed names for skills.

- Concepts are alphabetically sorted unless grouping by domain is clearer.

- Every concept mentioned in `README.md`, `AGENTS.md`, or `docs/` that is not self-evident belongs in `CONCEPTS.md`.

---


## CLAUDE.md conventions

Root `CLAUDE.md` is read automatically by Claude Code. It should:

- Be brief (under 20 lines) — point to `AGENTS.md` for authoritative instructions.

- Include any Claude Code-specific overrides not in `AGENTS.md` (e.g., tool permissions, MCP config notes).

- Never duplicate content from `AGENTS.md`.

Sub-directory `CLAUDE.md` options:

- **Symbolic link** (Linux/macOS): `ln -s AGENTS.md CLAUDE.md`

- **Stub file** (Windows or when symlinks are unavailable):

  ```markdown
  # Claude Guidance

  See [AGENTS.md](./AGENTS.md) for the authoritative instructions for this directory.
```text
