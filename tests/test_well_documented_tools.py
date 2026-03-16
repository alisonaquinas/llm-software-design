"""Behavior checks for the well-documented helper scripts."""

from __future__ import annotations

import subprocess
import tempfile
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SKILL_ROOT = REPO_ROOT / "skills" / "well-documented"


class TestWellDocumentedTools(unittest.TestCase):
    def test_audit_minimal_skips_recursive_directory_requirements(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "README.md").write_text("# Demo\n\n## Usage\n\nUse it.\n", encoding="utf-8")
            (root / "AGENTS.md").write_text(
                "# AGENTS\n\n## Layout\n\n```text\ndemo/\n```\n\n## Common Workflows\n\n1. Read files.\n\n## Invariants\n\n- Keep it real.\n",
                encoding="utf-8",
            )
            (root / "CLAUDE.md").write_text("# Claude Guidance\n\nSee [AGENTS.md](./AGENTS.md).\n", encoding="utf-8")
            (root / "src").mkdir()
            (root / "src" / "app.py").write_text("print('hi')\n", encoding="utf-8")

            proc = subprocess.run(
                ["bash", str(SKILL_ROOT / "scripts" / "audit-docs.sh"), "-r", str(root), "--maturity", "minimal", "-q"],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=False,
            )

            self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
            self.assertNotIn("D01", proc.stdout)
            self.assertNotIn("D02", proc.stdout)

    def test_add_file_headers_marks_bootstrap_and_preserves_shebang(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            script_path = root / "demo.sh"
            script_path.write_text("#!/usr/bin/env bash\necho hi\n", encoding="utf-8")

            subprocess.run(
                ["bash", str(SKILL_ROOT / "scripts" / "add-file-headers.sh"), "-t", str(script_path), "-d", "Run the demo command.", "-y"],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=True,
            )

            content = script_path.read_text(encoding="utf-8")
            self.assertIn("BOOTSTRAP HEADER: refine before merge.", content)
            self.assertEqual(content.count("#!/usr/bin/env bash"), 1)
            self.assertTrue(content.startswith("#!/usr/bin/env bash\n"))

    def test_add_file_headers_preserves_executable_bit(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            script_path = root / "demo.sh"
            script_path.write_text("#!/usr/bin/env bash\necho hi\n", encoding="utf-8")
            script_path.chmod(0o755)

            subprocess.run(
                ["bash", str(SKILL_ROOT / "scripts" / "add-file-headers.sh"), "-t", str(script_path), "-d", "Run the demo command.", "-y"],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=True,
            )

            self.assertEqual(oct(script_path.stat().st_mode & 0o777), oct(0o755))

    def test_init_docs_cli_template_and_minimal_mode(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "src").mkdir()
            (root / "src" / "main.py").write_text("print('hi')\n", encoding="utf-8")

            subprocess.run(
                [
                    "bash",
                    str(SKILL_ROOT / "scripts" / "init-docs.sh"),
                    "-r",
                    str(root),
                    "-n",
                    "demo-cli",
                    "-d",
                    "A small command-line tool.",
                    "--project-type",
                    "cli",
                    "--maturity",
                    "minimal",
                ],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=True,
            )

            readme = (root / "README.md").read_text(encoding="utf-8")
            self.assertIn("## What this CLI does", readme)
            self.assertIn("## Command map", readme)
            self.assertFalse((root / "CONCEPTS.md").exists())
            self.assertFalse((root / "src" / "README.md").exists())

    def test_init_docs_minimal_bootstrap_does_not_fail_audit_for_missing_license_link(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            subprocess.run(
                [
                    "bash",
                    str(SKILL_ROOT / "scripts" / "init-docs.sh"),
                    "-r",
                    str(root),
                    "-n",
                    "demo-cli",
                    "-d",
                    "A small command-line tool.",
                    "--project-type",
                    "cli",
                    "--maturity",
                    "minimal",
                ],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=True,
            )

            proc = subprocess.run(
                ["bash", str(SKILL_ROOT / "scripts" / "audit-docs.sh"), "-r", str(root), "--maturity", "minimal", "-q"],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=False,
            )

            self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
            self.assertNotIn("E01", proc.stdout)

    def test_audit_quiet_mode_keeps_pass_counts_in_score(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "README.md").write_text("# Demo\n\n## Installation\n\nInstall it.\n\n## Usage\n\nUse it.\n", encoding="utf-8")
            (root / "AGENTS.md").write_text(
                "# AGENTS\n\n## Layout\n\n```text\ndemo/\n├── README.md\n└── CLAUDE.md\n```\n\n## Common Workflows\n\n1. Read files.\n\n## Invariants\n\n- Keep it real.\n",
                encoding="utf-8",
            )
            (root / "CLAUDE.md").write_text("# Claude Guidance\n\nSee [AGENTS.md](./AGENTS.md).\n", encoding="utf-8")
            proc = subprocess.run(
                ["bash", str(SKILL_ROOT / "scripts" / "audit-docs.sh"), "-r", str(root), "--maturity", "minimal", "-q"],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
            self.assertIn("SCORE:", proc.stdout)
            self.assertNotIn("SCORE: 0 /", proc.stdout)


if __name__ == "__main__":
    unittest.main()
