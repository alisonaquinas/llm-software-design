# Claude agent SDLC for Planguage

Use this loop when changing repo-level agent manifests for the Planguage workflow.

- Keep the frontmatter concise and aligned with repo naming conventions.
- Match the agent responsibilities to the four Planguage roles and the command docs.
- Prefer maintenance guidance and validation commands over broad narrative prose.
- Re-check:
  - `agents/planguage-maintainer.md`
  - `commands/skill-development.md`
  - `commands/claude-command-sdlc.md`
  - `commands/claude-hook-sdlc.md`
- Validate with:
  - `markdownlint-cli2 agents/*.md`
  - targeted skill lint and validation for the Planguage family
