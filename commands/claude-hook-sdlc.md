# Claude hook SDLC for Planguage

Use this loop when changing `hooks/hooks.json` for the Planguage workflow.

- Start from the current `hooks/hooks.json` and preserve startup safety.
- Do not reintroduce `SessionStart` prompt hooks.
- Prefer conservative hook scaffolding over speculative command execution.
- Keep hook changes aligned with:
  - `commands/skill-development.md`
  - `commands/claude-command-sdlc.md`
  - `agents/planguage-maintainer.md`
- Validate the JSON structure after edits and confirm the hook file remains loadable.
