#!/usr/bin/env python3
"""
Fix remaining markdown linting issues:
- MD012: Multiple consecutive blank lines
- MD022: Headings need blank lines
- MD032: Lists need blank lines
"""

import re
import sys
from pathlib import Path


def fix_md012_multiple_blanks(content: str) -> str:
    """Fix MD012: Replace 2+ blank lines with 1 blank line."""
    return re.sub(r'\n{3,}', '\n\n', content)


def fix_md022_headings(content: str) -> str:
    """Fix MD022: Ensure headings have blank lines before/after."""
    lines = content.split('\n')
    result = []
    i = 0

    while i < len(lines):
        line = lines[i]

        # Check if this is a heading
        is_heading = line.startswith('#') and line[1] in (' ', '\t')

        if is_heading:
            # Add blank line before heading if not at start and previous line is not blank
            if i > 0 and result and result[-1].strip():
                result.append('')

            result.append(line)

            # Add blank line after heading if next line exists and is not blank
            if i + 1 < len(lines):
                next_line = lines[i + 1]
                if next_line.strip() and not next_line.startswith('#'):
                    result.append('')
        else:
            result.append(line)

        i += 1

    return '\n'.join(result)


def fix_md032_lists(content: str) -> str:
    """Fix MD032: Ensure lists have blank lines before/after."""
    lines = content.split('\n')
    result = []
    i = 0

    while i < len(lines):
        line = lines[i]

        # Check if this is a list item (bullet or numbered)
        is_list_item = (
            (line.lstrip().startswith('-') and len(line) > 1 and line[len(line) - len(line.lstrip()) + 1] == ' ') or
            (line.lstrip().startswith('*') and len(line) > 1 and line[len(line) - len(line.lstrip()) + 1] == ' ') or
            (re.match(r'^\s*\d+\.\s+', line))
        )

        if is_list_item:
            # Add blank line before list if previous line is not blank/empty
            if i > 0 and result and result[-1].strip():
                prev_line = result[-1]
                # Don't add if previous is also list item or heading
                prev_is_list = (
                    (prev_line.lstrip().startswith('-') and len(prev_line) > 1 and prev_line[len(prev_line) - len(prev_line.lstrip()) + 1] == ' ') or
                    (prev_line.lstrip().startswith('*') and len(prev_line) > 1 and prev_line[len(prev_line) - len(prev_line.lstrip()) + 1] == ' ') or
                    (re.match(r'^\s*\d+\.\s+', prev_line)) or
                    prev_line.startswith('#')
                )
                if not prev_is_list:
                    result.append('')

            result.append(line)
        else:
            result.append(line)

        i += 1

    return '\n'.join(result)


def process_file(filepath: Path) -> bool:
    """Process a single file. Return True if changed."""
    try:
        content = filepath.read_text(encoding='utf-8')
        original = content

        # Apply fixes
        content = fix_md012_multiple_blanks(content)
        content = fix_md022_headings(content)
        content = fix_md032_lists(content)

        if content != original:
            filepath.write_text(content, encoding='utf-8')
            print(f"✓ Fixed: {filepath}")
            return True
        return False
    except Exception as e:
        print(f"✗ Error processing {filepath}: {e}", file=sys.stderr)
        return False


def main():
    """Find and fix all markdown files."""
    repo_root = Path('.')
    md_files = sorted(repo_root.glob('**/*.md'))

    # Exclude certain directories
    exclude_dirs = {'.git', 'node_modules', 'built', '.venv', '__pycache__'}

    fixed_count = 0
    for md_file in md_files:
        # Skip excluded directories
        if any(part in exclude_dirs for part in md_file.parts):
            continue

        if process_file(md_file):
            fixed_count += 1

    print(f"\n✓ Fixed {fixed_count} files")


if __name__ == '__main__':
    main()
