# Installation Guide

## Claude Code

Add this repository as a local plugin source or publish it through a marketplace that points at this repo.

## Codex

Create junctions or symlinks from `~/.codex/skills/` into this repo's `skills/` directory.

### Windows PowerShell

```powershell
$repo = "C:\Users\aaqui\llm-software-design\skills"
Get-ChildItem -Directory $repo | ForEach-Object {
    $skill = $_.Name
    $target = Join-Path $env:USERPROFILE ".codex\skills\$skill"
    if (Test-Path $target) {
        Write-Host "Skipping $skill (already exists)"
    } else {
        New-Item -ItemType Junction -Path $target -Target $_.FullName | Out-Null
        Write-Host "Linked $skill"
    }
}
```

### Linux / macOS

```bash
REPO="$HOME/llm-software-design/skills"
for skill_path in "$REPO"/*; do
    [ -d "$skill_path" ] || continue
    skill="$(basename "$skill_path")"
    target="$HOME/.codex/skills/$skill"
    if [ -e "$target" ]; then
        echo "Skipping $skill (already exists)"
    else
        ln -s "$skill_path" "$target"
        echo "Linked $skill"
    fi
done
```

## Quality checks

```bash
make lint
make test
make build
make verify
make list
```

The Python helpers are also available directly:

```bash
python scripts/lint_skills.py solid
python scripts/validate_skills.py solid
python -m unittest discover -s tests -v
```

Legacy shell entrypoints remain available as compatibility shims:

```bash
bash linting/lint-skill.sh skills/solid
bash linting/lint-all.sh
bash validation/validate-skill.sh skills/solid
```
