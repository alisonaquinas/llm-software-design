# Installation Guide

## Claude Code

Add this repository as a local plugin source or publish it through a marketplace that points at this repo.

## Codex

Create junctions or symlinks from `~/.codex/skills/` into this repo's `skills/` directory.

### Windows PowerShell

```powershell
$repo = "C:\Users\aaqui\llm-software-design\skills"
foreach ($skill in "solid","oop","design-patterns","software-architecture","code-smells") {
    $target = "$env:USERPROFILE\.codex\skills\$skill"
    if (Test-Path $target) {
        Write-Host "Skipping $skill (already exists)"
    } else {
        New-Item -ItemType Junction -Path $target -Target "$repo\$skill"
        Write-Host "Linked $skill"
    }
}
```

### Linux / macOS

```bash
REPO="$HOME/llm-software-design/skills"
for skill in solid oop design-patterns software-architecture code-smells; do
    target="$HOME/.codex/skills/$skill"
    if [ -e "$target" ]; then
        echo "Skipping $skill (already exists)"
    else
        ln -s "$REPO/$skill" "$target"
        echo "Linked $skill"
    fi
done
```

## Quality Checks

```bash
make lint
make test
make build
make verify
```

The Python helpers are also available directly:

```bash
python scripts/lint_skills.py solid
python scripts/validate_skills.py solid
```

Legacy shell entrypoints remain available as compatibility shims:

```bash
bash linting/lint-skill.sh skills/solid
bash linting/lint-all.sh
bash validation/validate-skill.sh skills/solid
```
