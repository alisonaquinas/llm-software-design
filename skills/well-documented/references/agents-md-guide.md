# AGENTS.md Authoring Guide

## Purpose

`AGENTS.md` files are machine-readable documentation written for AI coding agents. Their goal is to give an agent everything it needs to safely navigate, modify, and extend a directory — without the agent having to infer structure from code alone.

An `AGENTS.md` is not a README. It does not explain the code to a curious human reader. It provides operational instructions to an agent that is about to make changes.

---

## Required sections

### 1. One-sentence summary

State what this directory is in a single sentence. No preamble.

```markdown
# AGENTS.md — Guide for AI Agents Working in `src/auth/`

Handles authentication and session management for the API layer.
```

### 2. Layout

A `tree`-style or table diagram of the files and sub-directories with one-line descriptions. Keep it accurate — an agent that reads a wrong layout wastes time.

```markdown
## Layout

```text
src/auth/
├── login.py          # Entry point for credential-based authentication
├── session.py        # Session lifecycle: create, refresh, expire
├── tokens.py         # JWT generation and validation
├── middleware.py      # FastAPI dependency that injects the current user
├── tests/
│   ├── test_login.py
│   └── test_tokens.py
└── AGENTS.md         # This file
```
```

Update the layout diagram whenever a file is added, removed, or renamed.

### 3. Key workflows

Step-by-step procedures for the changes an agent is most likely to make. Write them as numbered lists. Include exact commands when relevant.

```markdown
## Workflows

### Adding a new authentication provider

1. Add the provider class to `login.py`, implementing the `AuthProvider` interface.
2. Register it in `login.py:PROVIDERS` dict.
3. Add integration tests in `tests/test_login.py`.
4. Update the layout diagram above.
5. Run `make test` before committing.
```

### 4. Invariants

A "Do Not Violate" list. These are hard rules that must always hold, even if the agent cannot see an obvious reason why.

```markdown
## Invariants — Do Not Violate

- Every public function in `tokens.py` must validate inputs before processing.
- Session tokens must never be logged; use `[REDACTED]` in log lines.
- `middleware.py` must not import from `login.py` (creates a circular dependency).
- All test files must cover both success and rejection paths for each auth method.
```

### 5. Cross-references

Links to parent, sibling, and child `AGENTS.md` files, and to any globally relevant documentation. Every `AGENTS.md` at depth > 0 must include this section.

```markdown
## See Also

- [Parent AGENTS.md](../AGENTS.md) — API layer conventions
- [Root AGENTS.md](../../AGENTS.md) — Repo-wide invariants and commit rules
- [src/users/ AGENTS.md](../users/AGENTS.md) — User model used by auth middleware
- [CONCEPTS.md](../../CONCEPTS.md) — Definitions of Session, Token, and AuthProvider
```

---

## Optional sections

Include these only when they add information an agent cannot infer from code:

### Testing guidance

How to run tests for this directory specifically; any known flaky tests or test prerequisites.

### Performance notes

Latency budgets, caching behavior, or resource constraints that affect how code should be written.

### Known issues

Outstanding bugs or tech debt that an agent should be aware of to avoid making them worse.

### Platform notes

Environment-specific behavior: Windows vs. Unix paths, container vs. bare-metal differences, etc.

---

## Anti-patterns to avoid

| Anti-pattern | Why it's harmful |
| --- | --- |
| Duplicating content from `README.md` | Two files to maintain; they drift; agent gets conflicting info |
| Vague invariants like "write clean code" | Provides no actionable constraint |
| Outdated layout diagram | Agent wastes time looking for files that don't exist |
| Missing parent cross-reference | Agent can't navigate up the tree without reading filesystem |
| Listing every file without descriptions | Agents need purpose, not just names |
| Writing for humans ("this is interesting because…") | AGENTS.md is operational, not narrative |

---

## Formatting rules

- Use Markdown headings (`##`, `###`) for sections.
- Use fenced code blocks with the `text` language for directory trees.
- Use tables for multi-column data (invariants with rationale, file lists with descriptions).
- Use numbered lists for sequential workflows; use bullet lists for non-sequential items.
- Do not use HTML in `AGENTS.md` files.
- Keep the file under 300 lines. If it grows larger, split the content into subtopic files and reference them.

---

## Keeping AGENTS.md in sync

`AGENTS.md` decays the moment the code diverges from it. Rules:

- When adding a file: add it to the layout diagram and update workflows if it changes any procedure.
- When removing a file: remove it from the diagram and update any invariants that referenced it.
- When renaming: update all cross-references in this file and in sibling `AGENTS.md` files.
- When changing an invariant: update the invariant list and commit the change with the code change.

Treat `AGENTS.md` as part of the code, not documentation separate from it.

---

## CLAUDE.md relationship

`CLAUDE.md` is a Claude Code-specific file that is automatically loaded. At the sub-directory level it should be:

- A symbolic link to `AGENTS.md` in the same directory (Linux/macOS).
- A one-line stub file on Windows or in environments where symlinks are unreliable:

```markdown
# Claude Guidance

See [AGENTS.md](./AGENTS.md) for the authoritative instructions for this directory.
```

Never put substantive content in a sub-directory `CLAUDE.md`. All content belongs in `AGENTS.md`.
