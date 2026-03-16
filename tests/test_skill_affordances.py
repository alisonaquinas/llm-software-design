"""Tests for repository-wide skill affordances.

These checks back the live test-drive improvements by ensuring every shipped
skill keeps the sections that make common requests discoverable and verifiable.
"""

from __future__ import annotations

import re
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SKILLS_ROOT = REPO_ROOT / "skills"


def _skill_dirs() -> list[Path]:
    return sorted(p for p in SKILLS_ROOT.iterdir() if p.is_dir())


class TestSkillAffordances(unittest.TestCase):
    def test_every_skill_has_quick_start(self):
        pattern = re.compile(r"^## Quick[- ]?Start", re.MULTILINE)
        for skill_dir in _skill_dirs():
            with self.subTest(skill=skill_dir.name):
                content = (skill_dir / "SKILL.md").read_text(encoding="utf-8")
                self.assertRegex(content, pattern)

    def test_every_skill_has_verification_section(self):
        pattern = re.compile(r"^## Verification", re.MULTILINE)
        for skill_dir in _skill_dirs():
            with self.subTest(skill=skill_dir.name):
                content = (skill_dir / "SKILL.md").read_text(encoding="utf-8")
                self.assertRegex(content, pattern)

    def test_every_skill_has_safety_notes(self):
        pattern = re.compile(r"^## Safety Notes", re.MULTILINE)
        for skill_dir in _skill_dirs():
            with self.subTest(skill=skill_dir.name):
                content = (skill_dir / "SKILL.md").read_text(encoding="utf-8")
                self.assertRegex(content, pattern)


if __name__ == "__main__":
    unittest.main()
