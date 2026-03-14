# Release Workflow

Releases are tag-driven. Pushing a `vX.Y.Z` tag to `main` triggers
`.github/workflows/release.yml`, which:

1. Provisions its own release prerequisites on the GitHub runner
2. Reads `.claude-plugin/plugin.json` and verifies the tag matches the plugin version
3. Runs `make test`
4. Runs `make all` to build fresh ZIP bundles in `built/`
5. Extracts the matching release notes from `CHANGELOG.md`
6. Creates a GitHub release and attaches `built/*.zip`
7. Dispatches `plugin-updated` to `alisonaquinas/llm-skills` only when `MARKETPLACE_DISPATCH_TOKEN` is configured

If the marketplace token is missing, the workflow skips the dispatch step and still publishes the release normally.

## Workflow Prerequisites

The workflow installs everything it needs before testing, including:

- `make`, `zip`, `unzip`, and `jq`
- Python plus `ruff` and `yamllint`
- Node 20 and `markdownlint-cli2`

## Release Steps

1. Update `.claude-plugin/plugin.json` so `version` matches the intended tag.
2. Move the relevant `Unreleased` notes into `## [x.y.z] - YYYY-MM-DD` in `CHANGELOG.md`.
3. Commit the release metadata.
4. Tag the commit with `vX.Y.Z`.
5. Push the branch and tag.

After the tag is pushed, the workflow performs the gated `make test` and `make all` steps automatically.

## Optional Secret

`MARKETPLACE_DISPATCH_TOKEN` is optional. When configured in the repository
Actions secrets, it allows the workflow to send a `repository_dispatch` event
to `alisonaquinas/llm-skills` after the GitHub release is created.
