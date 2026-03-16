"""Depth checks for language docstring reference guides.

These tests protect the richer docstring guidance added after the docstrings
catalog test-drive so thinner skills do not regress back to skeleton references.
"""

from __future__ import annotations

import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SKILLS_ROOT = REPO_ROOT / "skills"

DEPTH_SECTION_MARKERS = [
    "## Structural expectations",
    "## Interface-first expectations",
    "## Signature-first expectations",
    "## Core tag set",
    "## Attribute map",
    "## ABAP Doc shape",
    "## Package structure expectations",
    "## Help section map",
    "## Help text shape",
    "## Predicate contract shape",
    "## Markup patterns",
    "## Metadata boundaries",
    "## Recommended header fields",
    "## What to document",
    "## Required structure",
    "## Format selection",
    "## POD section map",
    "## Tooling notes",
    "## Dialect map",
]


class TestDocstringReferenceDepth(unittest.TestCase):
    def test_every_docstring_skill_has_depth_sections(self):
        for skill_dir in sorted(SKILLS_ROOT.glob("*-docstrings")):
            with self.subTest(skill=skill_dir.name):
                content = (skill_dir / "references" / "docstrings.md").read_text(
                    encoding="utf-8"
                )
                self.assertIn("## Anti-patterns", content)
                self.assertIn("## Reference starting points", content)
                self.assertTrue(
                    any(marker in content for marker in DEPTH_SECTION_MARKERS),
                    "expected at least one depth section marker",
                )


if __name__ == "__main__":
    unittest.main()
