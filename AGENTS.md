# AGENTS.md — Guide for AI Agents Working in This Repo

This file tells AI agents how to navigate, use, and contribute to this repository effectively.

## What This Repo Is

A collection of cross-compatible skills in `SKILL.md` format that help LLM agents reason about software design, object-oriented design, architecture, maintainability, language-specific coding conventions, and source-level API documentation. Skills work identically in Claude Code and Codex without modification.

## Repo Layout

```text
llm-software-design/
├── .claude-plugin/plugin.json
├── linting/
├── validation/
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md
│       ├── agents/
│       │   ├── openai.yaml
│       │   └── claude.yaml
│       ├── references/
│       ├── scripts/
│       └── assets/
├── docs/
├── AGENTS.md
├── INSTALL.md
├── LICENSE.md
└── README.md
```

## Reading Skills

- Start with a skill's `SKILL.md`.
- Load `references/*.md` only when the task needs extra depth on that subtopic.
- Run `scripts/` when a skill includes executable helpers.
- Treat `assets/` as reusable output material, not context to load by default.

## Skill Families and Catalogs

- `docs/language-best-practice-skills.md` catalogs the generated language review skills.
- `docs/docstring-skills.md` catalogs the generated source-documentation skills.
- `docs/language-skill-matrix.md` aligns the two generated language families by rank and language name.

## Modifying Skills

### Editing an existing skill

1. Read `skills/<name>/SKILL.md` before making changes.
2. Keep the SKILL.md body concise; move depth into `references/` when needed.
3. Update the Intent Router whenever new reference files are added.
4. If the description changes materially, update both `agents/openai.yaml` and `agents/claude.yaml`.
5. Use platform-neutral body language; say "the agent" instead of tool-specific names.
6. When a language has both a best-practice skill and a docstring skill, preserve parallel depth and naming quality across the pair unless there is a clear reason not to.

### Adding a new skill

1. Create `skills/<name>/` using kebab-case.
2. Add `SKILL.md` with valid YAML frontmatter containing only `name` and `description`.
3. Add `agents/openai.yaml` and `agents/claude.yaml`.
4. Add reference files only when they reduce repeated inline explanation.
5. Add the skill to the appropriate catalog document and to the language matrix when applicable.

## Invariants — Do Not Violate

- Every skill directory must contain `SKILL.md`.
- Every skill must contain `agents/openai.yaml`.
- Every skill must contain `agents/claude.yaml`.
- SKILL.md frontmatter must contain only `name` and `description`.
- Any referenced file in the Intent Router must exist.
- Do not create auxiliary docs inside skill directories.
- Do not commit secrets, tokens, or credentials.

## Cross-Compatibility Rules

| Concern | Rule |
| --- | --- |
| Body text | Use "the agent", not product-specific names |
| Skill format | Same `SKILL.md` body for both platforms |
| `agents/openai.yaml` | Required |
| `agents/claude.yaml` | Keep aligned with OpenAI metadata |
| `.claude-plugin/plugin.json` | Repo root only |

## Linting and Validation

Before committing a new or updated skill, run:

```bash
make lint
```

When a tighter loop is needed for one skill, use:

```bash
python scripts/lint_skills.py <skill-name>
python scripts/validate_skills.py <skill-name>
```

Compatibility wrappers remain available for one release cycle:

```bash
bash linting/lint-skill.sh skills/<name>
bash linting/lint-all.sh
bash validation/validate-skill.sh skills/<name>
```

To validate a skill qualitatively:

```bash
python scripts/validate_skills.py <skill-name>
```

## Commit Conventions

- Prefer conventional commit prefixes such as `feat:`, `fix:`, `docs:`, and `refactor:`.
- Scope to the skill name when practical.
- Do not amend published commits.
- Do not commit without running the baseline quality gate:
  - `make test`
  - `make build`
  - `make verify`
  - or the narrow Python equivalents when changing one skill in isolation

## Release Process

Before tagging a release:

1. Update `.claude-plugin/plugin.json` so `version` matches the intended tag.
2. Move the relevant `Unreleased` notes into a dated release entry in `CHANGELOG.md`.
3. Commit the release metadata.
4. Create and push the annotated tag.

The release workflow publishes the GitHub release and dispatches `plugin-updated` to `alisonaquinas/llm-skills`.

- It runs `make test`, then `make all`, attaches `built/*.zip`, and skips marketplace dispatch cleanly when the token is absent.
