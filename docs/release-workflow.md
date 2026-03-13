# Release Workflow

Releases are tag-driven. Pushing a `vX.Y.Z` tag to `main` triggers `.github/workflows/release.yml`, which:

1. Reads `.claude-plugin/plugin.json`
2. Verifies the tag matches the plugin version
3. Extracts the matching release notes from `CHANGELOG.md`
4. Creates a GitHub release
5. Dispatches `plugin-updated` to `alisonaquinas/llm-skills`

## Required Secret

Configure `MARKETPLACE_DISPATCH_TOKEN` in the repository Actions secrets. It must be able to send `repository_dispatch` events to `alisonaquinas/llm-skills`.

## Release Steps

1. Update `.claude-plugin/plugin.json` version.
2. Move the appropriate `Unreleased` notes into `## [x.y.z] - YYYY-MM-DD` in `CHANGELOG.md`.
3. Commit the release metadata.
4. Tag the commit with `vX.Y.Z`.
5. Push the branch and tag.
