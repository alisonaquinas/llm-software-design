#!/usr/bin/env python3
"""Summarize skill affordances across the repository.

This script is a lightweight maintenance aid for future skill test-drive passes.
It reports whether each skill exposes the high-value sections the repository now
expects to keep common requests discoverable and verifiable.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SKILLS_ROOT = REPO_ROOT / "skills"

SECTION_PATTERNS = {
    "intent_router": re.compile(r"^## Intent Router", re.MULTILINE),
    "quick_start": re.compile(r"^## Quick[- ]?Start", re.MULTILINE),
    "workflow": re.compile(r"^## Workflow", re.MULTILINE),
    "verification": re.compile(r"^## Verification", re.MULTILINE),
    "safety": re.compile(r"^## Safety Notes", re.MULTILINE),
}


def summarize_skill(skill_dir: Path) -> dict[str, object]:
    text = (skill_dir / "SKILL.md").read_text(encoding="utf-8")
    return {
        "name": skill_dir.name,
        **{key: bool(pattern.search(text)) for key, pattern in SECTION_PATTERNS.items()},
        "references": len(re.findall(r"`references/[^`]+\.md`", text)),
        "code_blocks": len(re.findall(r"^```", text, re.MULTILINE)) // 2,
    }


def iter_skills() -> list[Path]:
    return sorted(p for p in SKILLS_ROOT.iterdir() if p.is_dir())


def format_table(rows: list[dict[str, object]]) -> str:
    header = "| Skill | Intent Router | Quick Start | Workflow | Verification | Safety | Refs | Code blocks |"
    sep = "| --- | --- | --- | --- | --- | --- | ---: | ---: |"
    lines = [header, sep]
    for row in rows:
        cell = lambda v: "yes" if v else "no"
        lines.append(
            "| {name} | {intent_router} | {quick_start} | {workflow} | {verification} | {safety} | {references} | {code_blocks} |".format(
                name=row["name"],
                intent_router=cell(row["intent_router"]),
                quick_start=cell(row["quick_start"]),
                workflow=cell(row["workflow"]),
                verification=cell(row["verification"]),
                safety=cell(row["safety"]),
                references=row["references"],
                code_blocks=row["code_blocks"],
            )
        )
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("skill_names", nargs="*", help="optional subset of skill folders to report")
    args = parser.parse_args()

    selected = set(args.skill_names)
    skills = [p for p in iter_skills() if not selected or p.name in selected]
    rows = [summarize_skill(skill) for skill in skills]
    print(format_table(rows))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
