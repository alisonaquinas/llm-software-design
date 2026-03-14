---
name: well-documented
description: >
  enforce thorough, structured documentation across a repository or code project. use when the user asks to audit, initialize, normalize, or improve project documentation including README files, AGENTS.md files, CONCEPTS.md, design docs, folder-level documentation, or file-level header comments and docstrings.
---

# Well-Documented

Use this skill to bring a repository to a thorough, consistent documentation standard — one that serves both human readers and AI agents working in the codebase.

## Intent Router

| Need | Load |
| --- | --- |
| Full repository documentation structure standard | `references/structure-standard.md` |
| File header and docstring conventions by language | `references/file-headers.md` |
| AGENTS.md authoring guide for AI-navigable docs | `references/agents-md-guide.md` |
| Audit checklist and scoring rubric | `references/audit-checklist.md` |

---

## The Documentation Standard

A well-documented repository satisfies all of the following:

### Root-level required files

| File | Audience | Purpose |
| --- | --- | --- |
| `README.md` | Humans | What the project is, how to install, how to use, how to contribute |
| `AGENTS.md` | AI agents | Repo layout, workflows, invariants, how to modify safely |
| `CLAUDE.md` | AI agents (Claude) | Symlink or stub pointing to `AGENTS.md` |
| `CONCEPTS.md` | Humans + AI | One paragraph per important concept, each with cross-references |
| `CHANGELOG.md` | Humans | Release history following Keep a Changelog |

### Per-folder required files (recursive)

Every folder that contains source files or sub-folders must have:

- `README.md` — human-centered: what lives here, why, how to use it
- `AGENTS.md` — AI-centered: layout, modification rules, invariants for this subtree
- `CLAUDE.md` — symbolic link to `AGENTS.md` (or `../AGENTS.md` for platform-specific reasons)

Each `AGENTS.md` must cross-reference parent and sibling `AGENTS.md` files.

### Diagrams in human-centered documents

**PlantUML is the preferred diagramming tool** for all human-centered documents: `README.md`, `docs/` files, and any design document.

Use PlantUML for class diagrams, sequence diagrams, component and deployment diagrams, activity and state diagrams, and architecture overviews. Embed diagrams as fenced ` ```plantuml ` blocks or generate and reference `.svg`/`.png` outputs.

Diagrams must stay in sync with the code. When class names, component names, or workflows change, update the diagram in the same commit.

Do **not** use PlantUML in `AGENTS.md` files — AI agents read those as plain text. Use ASCII art or table-based layouts in `AGENTS.md` instead.

### CONCEPTS.md structure

```markdown
# Concepts

## <Concept Name>

<One paragraph describing the concept — what it is, why it matters, how it relates to the project.>

**See also:** [Related File](path/to/file.md), [`$related-skill`], [Other Concept](#other-concept)
```

Each concept entry has exactly one paragraph of prose, followed by a "See also" line with cross-references to documentation files, skills, or other concepts.

### Code file requirements

- Every code file that supports header comments must have a **file-level header** explaining the file's purpose, what it exports, and how it fits into the larger system (see `references/file-headers.md`).
- Every public function, class, method, and module must have a **docstring or documentation comment** following the language's dominant convention.
- Use `$[language]-docstrings` skills for language-specific docstring conventions.
- Use `$[language]-best-practice` skills for broader code quality standards.

---

## Commands

### `init-docs`

Bootstrap the full documentation structure for a repository that has none or minimal documentation.

**Steps:**

1. Read the repository layout with `tree -L 3` or equivalent.
2. For each directory (root and recursive), check for `README.md`, `AGENTS.md`, and `CLAUDE.md`.
3. Generate missing files:
   - `README.md`: title, one-line description, install steps, usage, contributing section.
   - `AGENTS.md`: repo layout diagram, key workflows, invariants, cross-references to parent/sibling `AGENTS.md` files.
   - `CLAUDE.md`: single-line stub: `# Claude Guidance\n\nSee [AGENTS.md](./AGENTS.md) for the authoritative repository instructions.`
4. Generate `CONCEPTS.md` at the root: infer important concepts from the codebase structure and existing documentation.
5. Ensure `CHANGELOG.md` exists; create a blank one if absent (use `$changelog` skill).
6. Report every file created.

### `audit-docs`

Scan the repository and report every gap against the documentation standard.

**Output format:**

```
PASS  README.md (root)
PASS  AGENTS.md (root)
FAIL  CLAUDE.md (root) — missing
PASS  CONCEPTS.md (root)
FAIL  src/utils/README.md — missing
FAIL  src/utils/AGENTS.md — missing
WARN  src/api/AGENTS.md — no cross-references to parent AGENTS.md
WARN  src/auth/login.py — no file-level header comment
FAIL  src/auth/user.py — public function `authenticate` has no docstring
...
SCORE: 14 / 21 items pass (67%)
```

Severity levels:
- `FAIL` — required element is absent
- `WARN` — element exists but does not meet quality bar (too short, missing cross-references, no docstrings)
- `PASS` — element is present and meets the standard
- `SKIP` — directory or file is excluded (see below)

**Exclusion rules** (do not audit):
- `node_modules/`, `vendor/`, `.venv/`, `__pycache__/`, `dist/`, `out/`, `build/`, `.git/`
- Binary files, images, generated files (`.min.js`, `.pb`, `.lock`)
- Test fixtures (`tests/fixtures/`, `testdata/`)

### `normalize-docs`

Bring all existing documentation files up to standard without replacing content that is already correct.

**Steps:**

1. Run `audit-docs` internally to find gaps.
2. For each `FAIL`:
   - Create the missing file using the same logic as `init-docs`.
3. For each `WARN`:
   - Append missing cross-references to `AGENTS.md` files.
   - Extend thin `README.md` files with missing sections.
   - Add file-level headers to code files that lack them.
4. Do not overwrite content that already meets the standard.
5. Report every file created or modified.

### `add-file-headers`

Add or update file-level header comments across all code files in a directory or the entire repo.

**Steps:**

1. Walk all code files (respecting exclusion rules above).
2. For each file, detect the language from the extension.
3. Check whether a file-level header comment already exists (first non-blank lines are a comment block / docstring).
4. If absent, generate and prepend an appropriate header (see `references/file-headers.md` for language templates).
5. If present but thin (fewer than 3 content lines), extend it without removing existing text.
6. Report every file modified.

### `add-docstrings`

Add missing docstrings to all undocumented public symbols in a file or directory.

**Steps:**

1. Parse the file for public functions, classes, methods, and modules.
2. For each undocumented symbol, generate a docstring in the language's dominant format (see `references/file-headers.md`).
3. Delegate language-specific style decisions to the appropriate `$[language]-docstrings` skill.
4. Insert the docstring immediately after the declaration line.
5. Report every symbol documented.

### `check-concepts`

Verify that `CONCEPTS.md` at the root is complete and up to date.

**Steps:**

1. Extract all terms that appear in `AGENTS.md` and `README.md` that look like domain-specific concepts (capitalized terms, quoted terms, skill names, etc.).
2. Cross-reference against existing entries in `CONCEPTS.md`.
3. Report missing entries and suggest paragraph drafts for each.
4. Verify that every `See also:` link in `CONCEPTS.md` resolves to a real file or anchor.

---

## Workflow

- always `audit-docs` first before writing anything, so the user sees the scope of the gap
- prefer `normalize-docs` for partial documentation; use `init-docs` only for new or nearly empty repos
- generate documentation that is accurate to the actual code — do not hallucinate APIs or purposes
- when generating `AGENTS.md` files, read the existing code to infer real invariants and workflows
- cross-references in `AGENTS.md` must use relative paths that actually resolve
- do not generate placeholder sections like "TODO: describe this" — either write real content or omit the section

---

## AGENTS.md Authoring Rules

An `AGENTS.md` file that fully serves an AI agent contains:

1. **What this directory is** — one sentence.
2. **Layout** — a `tree`-style or table diagram of files and sub-folders with one-line descriptions.
3. **Key workflows** — step-by-step procedures an agent would follow to make changes safely.
4. **Invariants** — a "Do Not Violate" list of structural or semantic rules that must always hold.
5. **Cross-references** — links to parent `AGENTS.md`, sibling `AGENTS.md` files, and any globally relevant files.

Every `AGENTS.md` at directory depth > 0 must include a line such as:

```markdown
See also: [parent AGENTS.md](../AGENTS.md) | [root AGENTS.md](../../AGENTS.md)
```

---

## CLAUDE.md Conventions

`CLAUDE.md` at the root is read automatically by the AI agent. It should:

- Be a concise stub that points to `AGENTS.md` for authoritative instructions.
- Optionally include any Claude-specific overrides not covered by `AGENTS.md`.
- Never duplicate content from `AGENTS.md`; always defer to it.

For sub-directories, `CLAUDE.md` is a symbolic link to `AGENTS.md` in the same directory, or contains a one-line pointer. This ensures that the agent picks up directory-level guidance regardless of which file it resolves first.

---

## Common Requests

```text
audit-docs
```

```text
init-docs — this is a new Python project
```

```text
normalize-docs
```

```text
add-file-headers src/
```

```text
add-docstrings src/api/
```

```text
check-concepts
```

---

## Safety Notes

- do not delete existing documentation content; only extend or correct it
- do not generate `AGENTS.md` or `CONCEPTS.md` content that misrepresents what the code actually does — read the code first
- do not create `CLAUDE.md` as a duplicate of `AGENTS.md`; it should be a stub or symlink
- symbolic links require OS support; on Windows, use a stub file instead of `ln -s`
- do not add file headers or docstrings to generated files, minified files, or vendored dependencies
- confirm before running `add-file-headers` or `add-docstrings` on large trees — these operations touch many files

## See Also

- `$changelog` — CHANGELOG.md authoring and maintenance
- `$semantic-versioning` — version management coordinated with documentation releases
- `$[language]-docstrings` — language-specific docstring conventions
- `$[language]-best-practice` — broader code quality standards
- `$code-smells` — identifying underdocumented or opaque code patterns
