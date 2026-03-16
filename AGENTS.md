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
- `docs/skill-test-drive-report.md` captures the latest live test-drive findings and the repo-wide fixes that resulted from that pass.

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

To inspect the current affordance baseline across a subset of skills, use:

```bash
python scripts/skill_affordance_report.py <skill-name>
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

To inspect the current affordance baseline across a subset of skills, use:

```bash
python scripts/skill_affordance_report.py <skill-name>
```

## Git Workflow

This repo uses **trunk-based development**. The developer works alone.

- Commit directly to `main`. Do not create feature branches or open pull requests.
- Push directly: `git push origin main`.
- For releases, tag the commit on `main` and push the tag.

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

**Local pre-release checklist:**

1. Run `make lint` — verify markdown, Python, YAML, and skill structure pass.
2. Run `make test-unit` — verify all Python unit tests pass.
3. Run `make verify` — verify skill ZIPs can be built and opened.
4. Update `.claude-plugin/plugin.json` so `version` matches the intended tag.
5. Move the relevant `Unreleased` notes into a dated release entry in `CHANGELOG.md`.
6. Commit with a message like `chore(release): bump to v<VERSION>`.
7. Create an annotated git tag: `git tag -a v<VERSION> -m "Release v<VERSION>"`.
8. Push both commit and tag: `git push --follow-tags`.

**GitHub Actions release workflow:**

When a tag matching `v*.*.*` is pushed:

1. The release workflow runs `make test` (lint + validate + unit tests).
2. Then runs `make build` to generate skill ZIPs.
3. Extracts release notes from `CHANGELOG.md`.
4. Creates a GitHub release with the ZIPs attached.
5. Dispatches `plugin-updated` to `alisonaquinas/llm-skills` (if token is configured).

**Nothing is released without passing lint, test, validate, and build gates.**
