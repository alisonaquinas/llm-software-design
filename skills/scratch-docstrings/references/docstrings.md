# Scratch documentation convention

## Preferred convention

block, sprite, and project comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer Scratch comments attached to sprites, scripts, and projects because Scratch has no formal docstring system and those comments survive inside the project data that external tools can inspect.

## Best targets

sprites, stage logic, custom blocks, major scripts, project overview notes

## Canonical syntax

```text
when green flag clicked
# comment: initialize score and reset costume
set [score v] to [0]
```

## Example

```text
Sprite comment:
- Purpose: Handle keyboard movement
- Inputs: arrow keys
- Side effects: updates x and y position
```


## What to document

For Scratch projects, the goal is to explain the behavior other people encounter in the editor.

- sprite or stage purpose
- variable meaning, especially global versus sprite-local state
- broadcasts, clone behavior, and major event entry points
- level flow, win or loss conditions, and scoring rules
- assumptions about costumes, backdrops, timing, or hidden setup blocks that affect gameplay

## External tool access

Scratch editor comments, sb3 project JSON inspection, educational tooling

```text
unzip project.sb3
inspect project.json for comment metadata
```

## Migration guidance

- convert declaration-adjacent comments incrementally so mixed-style files can be cleaned up safely over time
- avoid mixing competing documentation styles in one file unless a staged migration explicitly requires it
- verify generated docs, IDE help, or extracted metadata after making documentation changes

## Review checklist

- [ ] the chosen convention matches the surrounding toolchain or house style
- [ ] comments are attached to the declarations that external tools inspect
- [ ] summaries describe real behavior without invented guarantees
- [ ] parameters, returns, errors, and examples match the code
- [ ] extraction or verification commands are noted when they materially help review or CI

## Notes

Keep comments task-oriented and visual. Add a project-level overview when the logic spans multiple sprites or broadcasts.

## Anti-patterns

- adding comments to many small blocks while leaving the main sprite or game loop unexplained
- using comments that say what a block literally does instead of why the behavior matters
- omitting broadcast semantics or clone lifecycle notes that make the project understandable
- leaving project notes stale after control-flow or variable changes
- documenting a sprite in isolation when stage variables or shared messages are the real contract

## Reference starting points

- [Scratch Wiki](https://en.scratch-wiki.info/)
- project notes, remix instructions, and classroom handoff standards already used by the team
- gameplay or learning-objective requirements that explain the intended experience
