"""Behavior checks for the well-documented helper scripts."""

from __future__ import annotations

import os
import re
import uuid
import shutil
import subprocess
import shlex
import unittest
from contextlib import contextmanager
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SKILL_ROOT = REPO_ROOT / "skills" / "well-documented"
SKILL_SCRIPTS = SKILL_ROOT / "scripts"
_HAS_BASH = subprocess.run(["bash", "-lc", "true"], capture_output=True, text=True).returncode == 0


@contextmanager
def _temp_test_dir(prefix: str):
    """Yield a deterministic temp directory under repo for stable Windows behavior."""
    tmp_root = REPO_ROOT / "tmp-test"
    tmp_root.mkdir(exist_ok=True)
    path = tmp_root / f"{prefix}{uuid.uuid4().hex}"
    path.mkdir()
    try:
        yield path
    finally:
        shutil.rmtree(path, ignore_errors=True)

def _write_markdownlint_config(root: Path):
    (root / ".markdownlint.json").write_text('{"default": false}\n', encoding="utf-8")


def _to_bash_path(path: Path | str) -> str:
    """Convert a local filesystem path to a bash-friendly POSIX path."""
    text = Path(path).as_posix()
    if re.match(r"^[A-Za-z]:[\\/]", text):
        return "/mnt/" + text[0].lower() + text[2:]
    return text


def _run_bash(args: list[Path | str], **kwargs) -> subprocess.CompletedProcess[str]:
    if "markdownlint" in kwargs:
        use_markdownlint = kwargs.pop("markdownlint")
    else:
        use_markdownlint = True
    if not _HAS_BASH:
        raise unittest.SkipTest("bash is unavailable in this environment")
    env = kwargs.pop("env", os.environ.copy())
    if not use_markdownlint:
        env = env.copy()
        args = list(args) + ["--no-markdownlint"]
        env["PATH"] = "/usr/bin:/bin"
    kwargs["env"] = env
    command_parts = []
    for arg in args:
        text = str(arg)
        if text.startswith("-"):
            command_parts.append(shlex.quote(text))
            continue
        candidate = Path(text)
        if candidate.exists():
            command_parts.append(shlex.quote(_to_bash_path(text)))
            continue
        if re.match(r"^[A-Za-z]:[\\/]", text) or "\\" in text or "/" in text:
            command_parts.append(shlex.quote(_to_bash_path(text)))
        else:
            command_parts.append(shlex.quote(text))
    command = " ".join(command_parts)
    return subprocess.run(["bash", "-lc", command], **kwargs)


class TestWellDocumentedTools(unittest.TestCase):
    def test_audit_minimal_skips_recursive_directory_requirements(self):
        with _temp_test_dir("audit-minimal-") as tmp:
            root = Path(tmp)
            (root / "README.md").write_text("# Demo\n\n## Usage\n\nUse it.\n", encoding="utf-8")
            (root / "AGENTS.md").write_text(
                "# AGENTS\n\n## Layout\n\n```text\ndemo/\n```\n\n## Common Workflows\n\n1. Read files.\n\n## Invariants\n\n- Keep it real.\n",
                encoding="utf-8",
            )
            (root / "CLAUDE.md").write_text("# Claude Guidance\n\nSee [AGENTS.md](./AGENTS.md).\n", encoding="utf-8")
            _write_markdownlint_config(root)
            (root / "src").mkdir()
            (root / "src" / "app.py").write_text("print('hi')\n", encoding="utf-8")

            proc = _run_bash(
                [
                    SKILL_SCRIPTS / "audit-docs.sh",
                    "-r",
                    root,
                    "--maturity",
                    "minimal",
                    "-q",
                ],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=False,
                markdownlint=False,
            )

            self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
            self.assertNotIn("D01", proc.stdout)
            self.assertNotIn("D02", proc.stdout)

    def test_add_file_headers_marks_bootstrap_and_preserves_shebang(self):
        with _temp_test_dir("add-header-mark-") as tmp:
            root = Path(tmp)
            script_path = root / "demo.sh"
            script_path.write_text("#!/usr/bin/env bash\necho hi\n", encoding="utf-8")

            _run_bash(
                [
                    SKILL_SCRIPTS / "add-file-headers.sh",
                    "-t",
                    script_path,
                    "-d",
                    "Run the demo command.",
                    "-y",
                ],
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
        if os.name == "nt":
            self.skipTest("Executable mode assertion is not portable on Windows")

        with _temp_test_dir("add-header-perm-") as tmp:
            root = Path(tmp)
            script_path = root / "demo.sh"
            script_path.write_text("#!/usr/bin/env bash\necho hi\n", encoding="utf-8")
            script_path.chmod(0o755)

            _run_bash(
                [
                    SKILL_SCRIPTS / "add-file-headers.sh",
                    "-t",
                    script_path,
                    "-d",
                    "Run the demo command.",
                    "-y",
                ],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=True,
            )

            self.assertEqual(oct(script_path.stat().st_mode & 0o777), oct(0o755))

    def test_init_docs_cli_template_and_minimal_mode(self):
        with _temp_test_dir("init-docs-cli-") as tmp:
            root = Path(tmp)
            _write_markdownlint_config(root)
            (root / "src").mkdir()
            (root / "src" / "main.py").write_text("print('hi')\n", encoding="utf-8")

            _run_bash(
                [
                    SKILL_SCRIPTS / "init-docs.sh",
                    "-r",
                    root,
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
        with _temp_test_dir("init-docs-minimal-") as tmp:
            root = Path(tmp)
            _write_markdownlint_config(root)
            _run_bash(
                [
                    SKILL_SCRIPTS / "init-docs.sh",
                    "-r",
                    root,
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

            proc = _run_bash(
                [
                    SKILL_SCRIPTS / "audit-docs.sh",
                    "-r",
                    root,
                    "--maturity",
                    "minimal",
                    "-q",
                ],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=False,
                markdownlint=False,
            )

            self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
            self.assertNotIn("E01", proc.stdout)

    def test_audit_quiet_mode_keeps_pass_counts_in_score(self):
        with _temp_test_dir("audit-quiet-") as tmp:
            root = Path(tmp)
            (root / "README.md").write_text("# Demo\n\n## Installation\n\nInstall it.\n\n## Usage\n\nUse it.\n", encoding="utf-8")
            (root / "AGENTS.md").write_text(
                "# AGENTS\n\n## Layout\n\n```text\ndemo/\n├── README.md\n└── CLAUDE.md\n```\n\n## Common Workflows\n\n1. Read files.\n\n## Invariants\n\n- Keep it real.\n",
                encoding="utf-8",
            )
            (root / "CLAUDE.md").write_text("# Claude Guidance\n\nSee [AGENTS.md](./AGENTS.md).\n", encoding="utf-8")
            _write_markdownlint_config(root)
            proc = _run_bash(
                [
                    SKILL_SCRIPTS / "audit-docs.sh",
                    "-r",
                    root,
                    "--maturity",
                    "minimal",
                    "-q",
                ],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
                check=False,
                markdownlint=False,
            )
            self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
            self.assertIn("SCORE:", proc.stdout)
            self.assertNotIn("SCORE: 0 /", proc.stdout)


if __name__ == "__main__":
    unittest.main()
