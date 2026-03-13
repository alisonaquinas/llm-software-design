# Skill Linting Rules — Reference

Authoritative specification for all 12 lint checks. These rules enforce structural
correctness and consistency across all skills.

---

## Quick Reference

| ID | Check | Severity | Pass Condition | Typical Fix |
|---|---|---|---|---|
| L01 | Frontmatter fields | FAIL | Only `name` and `description` | Remove extra YAML fields |
| L02 | name format | FAIL | kebab-case, ≤64 chars, matches folder | Rename skill or folder |
| L03 | Required files | FAIL | SKILL.md, agents/openai.yaml, agents/claude.yaml present | Create missing files |
| L04 | Agent YAML fields | FAIL | Both agent files have `display_name`, `short_description`, `default_prompt` | Add missing fields |
| L05 | short_description length | FAIL/WARN | 25–64 characters | Truncate (FAIL >64) or expand (WARN <25) |
| L06 | Body line count | WARN/FAIL | Under 500 lines (warn ≥450) | Move content to `references/` |
| L07 | No dangling references | FAIL | Every `references/*.md` mentioned in body exists on disk | Create missing files or remove references |
| L08 | Script syntax | FAIL | All `scripts/*.sh` pass `bash -n` check | Fix shell syntax errors |
| L09 | No platform language | FAIL | Body doesn't mention "Claude Code" or "Codex" | Replace with "the agent" |
| L10 | No forbidden files | FAIL | No README.md, CHANGELOG.md, etc. in skill dir | Delete auxiliary files |
| L11 | No second-person | WARN | Body doesn't use "You should", "You can", etc. | Rewrite in imperative form |
| L12 | Markdownlint | FAIL | All `.md` files pass markdownlint-cli2 | Run `markdownlint-cli2 --fix` |

---

## Rules — Full Specification

### L01: Frontmatter Fields

**Check:** SKILL.md frontmatter contains exactly `name` and `description`, no other YAML fields.

**Why:** Keeps metadata clean and consistent. Extra fields (e.g., `version`, `author`, `tags`)
add to the context window and diverge from the standard SKILL.md contract.

**Pass condition:** Frontmatter has exactly two fields: `name` and `description`.

**Fail condition:** Frontmatter has extra fields or is missing one of these two.

**Typical fix:**

```yaml
# WRONG:
---
name: git
description: >
  Git workflows
version: 1.0
tags: [vcs, branching]
---

# RIGHT:
---
name: git
description: >
  Git workflows
---
```

**Known exceptions:** None. This is a hard invariant.

---

### L02: name Format

**Check:** `name` field is:

- lowercase kebab-case (digits, hyphens, lowercase letters only)
- ≤64 characters
- matches the skill directory name

**Why:** Kebab-case ensures compatibility with file systems and shell scripts. Length limit
keeps skill names concise and fits in UI constraints. Matching ensures no confusion between
SKILL.md and folder structure.

**Pass condition:** All three constraints met.

**Fail condition:** Any constraint violated.

**Typical fixes:**

```bash
# WRONG: CamelCase, too long
name: GitWorkflowAdvanced

# RIGHT: kebab-case, concise
name: git

# WRONG: doesn't match folder
folder: skills/git, but name: version-control

# RIGHT: matching
folder: skills/git, name: git
```

**Known exceptions:** None. This is a hard invariant.

---

### L03: Required Files

**Check:** All three required files exist:

- `SKILL.md`
- `agents/openai.yaml`
- `agents/claude.yaml`

**Why:** These files are required for cross-platform skill loading. SKILL.md is the core;
both agent YAML files enable the skill to work in Claude Code and Codex UIs.

**Pass condition:** All three files present.

**Fail condition:** Any file missing.

**Typical fix:**

```bash
touch agents/openai.yaml agents/claude.yaml
# Then populate with required fields (see L04)
```

**Known exceptions:** None. This is a hard invariant.

---

### L04: Agent YAML Fields

**Check:** Both `agents/openai.yaml` and `agents/claude.yaml` contain:

- `display_name` — human-readable title
- `short_description` — 25–64 char summary
- `default_prompt` — suggested usage prompt

**Why:** These fields are required for UI presentation and agent invocation in both platforms.

**Pass condition:** Both YAML files have all three fields.

**Fail condition:** Either file is missing any of the three fields.

**Typical fix:**

```yaml
interface:
  display_name: "Git"
  short_description: "Git workflows and branching"
  default_prompt: "Use $git to rebase my feature branch."
```

**Known exceptions:** None. This is a hard invariant for cross-compatibility.

---

### L05: short_description Length

**Check:** `short_description` field in both agent YAML files is 25–64 characters.

**Why:** Too short (<25) means vague and unhelpful. Too long (>64) exceeds UI chip width
and gets truncated in Codex. The 25–64 range is optimized for readability.

**Pass condition:** Both descriptions are 25–64 chars.

**Fail condition:**

- **FAIL:** Description >64 chars (exceeds UI width)
- **WARN:** Description <25 chars (too vague)

**Typical fix:**

```yaml
# WRONG: too long (86 chars)
short_description: "Complete SQLite workflows including queries, backups, schema diffing, and migrations"

# RIGHT: 54 chars
short_description: "SQLite queries, backups, diffing, and migrations"
```

**Known exceptions:** None. This is a hard limit for UI compatibility.

---

### L06: Body Line Count

**Check:** SKILL.md body (excluding frontmatter) is under 500 lines.

**Why:** The context window is shared. Skills should be concise and lazy-load detailed
documentation into `references/`.

**Pass condition:** Body <450 lines.

**Warn condition:** Body 450–499 lines (approaching limit).

**Fail condition:** Body ≥500 lines.

**Typical fix:**

```bash
# Count current body lines:
tail -n +4 SKILL.md | wc -l

# If >450, move detailed sections to references/:
# 1. Identify sections that could be separate docs
# 2. Create references/topic.md with that content
# 3. Replace inline content with "See references/topic.md for..."
# 4. Add to Intent Router in SKILL.md
```

**Known exceptions:** Some complex skills (e.g., `docker`) may justifiably exceed 450.
If warranted, add to `.lintignore`:

```text
L06
```

---

### L07: No Dangling References

**Check:** Every file mentioned in the body as `references/something.md` actually exists
on disk.

**Why:** Dangling references confuse the agent and waste tokens on "file not found" errors.

**Pass condition:** All mentioned reference files exist.

**Fail condition:** One or more referenced files are missing.

**Typical fix:**

```bash
# Find dangling references:
grep -o 'references/[a-z0-9._-]\+\.md' SKILL.md | sort -u

# Create missing files or remove references:
touch references/missing-topic.md  # then populate it
# OR edit SKILL.md to remove the reference
```

**Known exceptions:** None. All references must exist.

---

### L08: Script Syntax

**Check:** All shell scripts in `scripts/*.sh` pass `bash -n` (syntax check).

**Why:** Syntax errors cause agent execution failures. Checking early prevents bad scripts
from shipping.

**Pass condition:** All `.sh` files pass `bash -n`.

**Fail condition:** Any `.sh` file has syntax errors.

**Typical fix:**

```bash
# Check syntax:
bash -n scripts/my-script.sh

# Common errors: missing quotes, unbalanced braces, incorrect conditionals
# Fix and verify:
bash -n scripts/my-script.sh  # should return 0 (exit code)
```

**Known exceptions:** None. All scripts must be syntactically correct.

---

### L09: No Platform Language

**Check:** SKILL.md body text doesn't mention "Claude Code" or "Codex" by name.

**Why:** Skills must be platform-neutral. Using "the agent" instead keeps content
reusable across Claude Code and Codex without modification.

**Pass condition:** No mentions of "Claude Code" or "Codex" in prose (code samples OK).

**Fail condition:** Any mention found outside code blocks.

**Typical fix:**

```markdown
# WRONG:
In Claude Code, you can use the following syntax...
Codex supports this differently...

# RIGHT:
The agent can use the following syntax...
For alternative approaches, see...
```

**Note:** Platform-specific language in code examples (e.g., `# Claude Code plugin`) is OK;
this check strips code fences before scanning.

**Known exceptions:** The `skill-creator` skill legitimately documents both platforms.
Add `.lintignore`:

```text
L09
```

---

### L10: No Forbidden Files

**Check:** Skill directory doesn't contain auxiliary documentation:

- `README.md` — belongs in repo root or references/
- `CHANGELOG.md` — use repo-level CHANGELOG
- `INSTALLATION_GUIDE.md` — use repo INSTALL.md
- `QUICK_REFERENCE.md` — inline in SKILL.md
- `IMPLEMENTATION.md` — not needed; agents don't use

**Why:** Auxiliary files create confusion about what the agent actually loads and add
unnecessary files to the skill folder.

**Pass condition:** None of these files exist in the skill directory.

**Fail condition:** Any of these files found.

**Typical fix:**

```bash
# Remove auxiliary files:
rm skills/my-skill/README.md
rm skills/my-skill/CHANGELOG.md

# Move content into SKILL.md, references/, or repo root as appropriate
```

**Known exceptions:** None. Keep skill directories minimal.

---

### L11: No Second-Person Language

**Check:** SKILL.md body doesn't use "You should", "You can", "You need", "You must",
"You will", or "You are".

**Why:** Second-person language is indirect and vague. Imperative form is clearer:

- "Use `git rebase`" (imperative) beats "You should use `git rebase`" (second-person)
- "Run the script" beats "You can run the script"

**Pass condition:** No second-person verbs detected.

**Warn condition:** Second-person language found; code block content is excluded from check.

**Fail condition:** None (this is a WARN only).

**Typical fix:**

```markdown
# WRONG:
You should run this command. You can configure it like this.

# RIGHT:
Run this command. Configure it like this.
```

**Known exceptions:** Some skills may use second-person naturally in examples or dialogue.
If abundant, add `.lintignore`:

```text
L11
```

---

### L12: Markdownlint Compliance

**Check:** All `.md` files in the skill pass `markdownlint-cli2` with the repo's
`.markdownlint-cli2.jsonc` configuration.

**Why:** Consistent Markdown formatting improves readability and prevents rendering issues.

**Pass condition:** `markdownlint-cli2 skills/<name>/**/*.md` exits 0.

**Fail condition:** Any linting errors found.

**Typical fix:**

```bash
# Install markdownlint-cli2:
npm install -g @markdownlint/cli2

# Run auto-fix (fixes many issues):
markdownlint-cli2 --fix "skills/<name>/**/*.md"

# Check result:
markdownlint-cli2 "skills/<name>/**/*.md"
```

**Known exceptions:** If specific linting rules conflict with skill design,
update `.markdownlint-cli2.jsonc` at repo root; do NOT add `.lintignore` per-skill.

---

## Override Mechanism: .lintignore

A skill can suppress specific rule IDs by creating a `.lintignore` file in the skill directory.

**Format:** One rule ID per line.

**Example:**

```text
# .lintignore in skills/skill-creator/
L09
L11
```

This tells the linter to skip L09 (platform language) and L11 (second-person) for
`skill-creator`, since that skill legitimately documents cross-platform differences.

**Use sparingly.** Each suppression should be documented with a comment in the `.lintignore`
file or in the skill's CLAUDE.md section.

---

## Verification Checklist

Before committing a modified or new skill, run:

```bash
bash linting/lint-skill.sh skills/<name>
```

Fix all FAIL items. WARN items are suggestions; address them where practical.

For pre-commit integration:

```bash
bash linting/lint-all.sh  # should exit 0
```
