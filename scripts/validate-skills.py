#!/usr/bin/env python3
"""
Validate .agents/skills/ structure and content.

Usage:
  python3 scripts/validate-skills.py

Checks:
  1. Directory name matches frontmatter `name`
  2. Frontmatter `description` exists and is non-empty
  3. Relative Markdown links are reachable (file exists)

Exit codes:
  0 - All checks passed
  1 - One or more checks failed
"""

import re
import sys
from pathlib import Path

SKILLS_DIR = Path(__file__).resolve().parent.parent / '.agents' / 'skills'

# Regex patterns
FRONTMATTER_PATTERN = re.compile(r'^---\s*\n(.*?)\n---', re.DOTALL)
LINK_PATTERN = re.compile(r'\[([^\]]*)\]\(([^)]+)\)')


def parse_frontmatter(content: str) -> dict[str, str]:
    """Extract key-value pairs from YAML frontmatter."""
    match = FRONTMATTER_PATTERN.match(content)
    if not match:
        return {}

    result = {}
    for line in match.group(1).splitlines():
        line = line.strip()
        if ':' in line:
            key, _, value = line.partition(':')
            result[key.strip()] = value.strip()
    return result


def extract_relative_links(content: str) -> list[str]:
    """Extract relative Markdown links (excluding http/https URLs)."""
    links = []
    for match in LINK_PATTERN.finditer(content):
        url = match.group(2)
        # Skip absolute URLs
        if url.startswith('http://') or url.startswith('https://'):
            continue
        # Skip anchors
        if url.startswith('#'):
            continue
        # Remove anchor fragment if present
        url = url.split('#')[0]
        if url:
            links.append(url)
    return links


def validate_skill(skill_dir: Path) -> list[str]:
    """Validate a single skill directory. Returns list of error messages."""
    errors = []
    skill_md = skill_dir / 'SKILL.md'

    if not skill_md.exists():
        errors.append(f'SKILL.md not found in {skill_dir.name}')
        return errors

    content = skill_md.read_text(encoding='utf-8')
    frontmatter = parse_frontmatter(content)
    dir_name = skill_dir.name

    # Check 1: name matches directory
    name = frontmatter.get('name', '')
    if name != dir_name:
        errors.append(
            f'frontmatter name "{name}" does not match directory "{dir_name}"'
        )

    # Check 2: description exists and non-empty
    description = frontmatter.get('description', '')
    if not description:
        errors.append('frontmatter description is missing or empty')

    # Check 3: relative links are reachable
    links = extract_relative_links(content)
    for link in links:
        link_path = (skill_dir / link).resolve()
        if not link_path.exists():
            errors.append(f'broken link: {link} (resolved to {link_path})')

    return errors


def main() -> int:
    if not SKILLS_DIR.exists():
        print(f'ERROR: Skills directory not found: {SKILLS_DIR}')
        return 1

    skill_dirs = sorted(
        d for d in SKILLS_DIR.iterdir()
        if d.is_dir() and not d.name.startswith('.')
    )

    if not skill_dirs:
        print('WARNING: No skill directories found')
        return 0

    total = 0
    failed = 0
    all_errors: dict[str, list[str]] = {}

    for skill_dir in skill_dirs:
        total += 1
        errors = validate_skill(skill_dir)
        if errors:
            failed += 1
            all_errors[skill_dir.name] = errors

    # Print results
    if all_errors:
        print('Validation errors:\n')
        for skill_name, errors in all_errors.items():
            print(f'  [{skill_name}]')
            for error in errors:
                print(f'    - {error}')
            print()

    passed = total - failed
    print(f'Results: {passed}/{total} skills passed validation')

    return 1 if failed > 0 else 0


if __name__ == '__main__':
    sys.exit(main())
