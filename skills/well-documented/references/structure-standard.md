# Repository Documentation Structure Standard

This standard defines **what good documentation looks like**, but it does not force the same file set into every repository or every directory. Choose a documentation maturity level first, then apply these expectations.

## Root-level baseline

### Always high-value

| File | Audience | Typical expectation | Notes |
| --- | --- | --- | --- |
| `README.md` | Humans | Strongly expected | Explain purpose, setup, usage, and development flow |
| `AGENTS.md` | AI agents | Strongly expected | Explain layout, workflows, invariants, and safe-editing rules |
| `CLAUDE.md` | Claude Code | Expected when Claude workflows matter | Keep it as a stub or symlink to `AGENTS.md` plus any Claude-specific overrides |

### Depends on repository shape

| File | Audience | When it becomes important |
| --- | --- | --- |
| `CONCEPTS.md` | Humans + AI | When the domain language is non-obvious or reused across many files |
| `CHANGELOG.md` | Humans | When the project publishes releases, tracks notable changes, or has external consumers |
| `docs/` | Humans | When the structure, architecture, or design decisions are too large for the README |

## Maturity-based expectations

### Minimal

At `minimal`, the root docs carry most of the load. Folder-level docs are opt-in and should be created only where they clearly reduce confusion.

### Standard

At `standard`, document the root plus any **doc-worthy directory**:

- public API boundaries
- entrypoint directories such as `src/`, `app/`, `packages/`, `services/`, `cmd/`, `api/`, `scripts/`
- high-change areas with local invariants
- directories with multiple important submodules

### Full

At `full`, every meaningful source directory should usually have:

- a local `README.md` for humans
- a local `AGENTS.md` for agents
- a `CLAUDE.md` stub or symlink when the workflow expects it

This is the explicit opt-in maturity for recursive folder docs.

## docs/ folder structure

The `docs/` folder holds long-form design and reference documentation intended for human readers. Organize it around the project's major concerns, not around every source directory.

Recommended layout:

```text
docs/
├── README.md              # index of all docs in this folder
├── architecture.md        # system-level architecture overview
├── design/                # detailed design documents
│   ├── README.md
│   ├── <feature>.md
│   └── decisions/         # architecture decision records
│       ├── README.md
│       └── 0001-<title>.md
└── api/                   # public API reference when not auto-generated
    └── README.md
```

## Diagrams in human-centered documents

**PlantUML is the preferred diagramming tool** for embedding visual structure in `README.md`, `docs/` files, and other human-centered documentation.

Use PlantUML for:

- class and object diagrams
- sequence diagrams
- component and deployment diagrams
- activity and state diagrams
- use-case diagrams
- mind maps for concept relationships

Embed as fenced code blocks:

````markdown
```plantuml
@startuml
<diagram content>
@enduml
```
````

Or generate `.svg` or `.png` outputs and reference them as images.

Keep diagrams in sync with the code they describe. When a diagram references names that change, update the diagram in the same change set.

Do not use PlantUML in `AGENTS.md` files. Use ASCII trees or tables there.

## README.md standard sections

A complete human-centered root `README.md` usually contains:

1. title
2. one-line description
3. overview or architecture
4. prerequisites
5. installation or setup
6. usage
7. configuration
8. development workflow
9. contributing guidance
10. license

Project-type templates can legitimately emphasize a different order, but the README should still answer those questions somewhere.

A folder-level `README.md` can be lighter. It should at least explain:

- what lives in the directory
- why the directory exists
- the most likely entrypoints or edit surfaces
- links to deeper docs when they exist

## AGENTS.md standard sections

A complete `AGENTS.md` usually contains:

1. what this area is for
2. layout
3. common workflows
4. invariants
5. cross-references

Cross-reference format at depth greater than zero:

```markdown
## See Also

- [Parent AGENTS.md](../AGENTS.md)
- [Root AGENTS.md](../../AGENTS.md)
- [Sibling module AGENTS.md](../sibling/AGENTS.md)
```

## CONCEPTS.md standard structure

```markdown
# Concepts

## <Concept Name>

<One paragraph of prose: what it is, why it matters, how it fits into the project.>

**See also:** [path/to/related.md](path/to/related.md), [`$skill-name`], [Other Concept](#other-concept)
```

Rules:

- each concept gets one focused paragraph
- `See also` lines use relative paths for local files and backticked skill names for skills
- concepts are alphabetized unless domain grouping is clearer
- concepts should explain vocabulary that is reused across code and docs, not obvious English words

## CLAUDE.md conventions

Root `CLAUDE.md` should be brief and point to `AGENTS.md` for authoritative instructions.

Sub-directory `CLAUDE.md` options:

- symbolic link on platforms that support it
- short stub file on platforms where symlinks are awkward

Example stub:

```markdown
# Claude Guidance

See [AGENTS.md](./AGENTS.md) for the authoritative instructions for this directory.
```

## What to avoid

- recursive folder-doc requirements as the default starting point
- duplicate content between `AGENTS.md` and `CLAUDE.md`
- placeholder-heavy docs that look complete but are not trustworthy
- diagrams or layout sections that were never updated after the code changed
