#!/usr/bin/env bash
# Scaffold a new skill in the SKILL repo: directory, stub SKILL.md,
# README row (alphabetical inside the domain table), the two flat repository
# symlinks required by the pre-commit hook, and optionally a local Codex skill
# symlink for slash-menu discovery.
# Stages repository files with `git add` but does NOT commit — the agent fills
# in SKILL.md, then publishes with publish-skill.sh.
#
# Usage: scaffold-skill.sh [--install-codex] <domain> <skill-name> "<one-line purpose>"
#   domain ∈ infrastructure | automation | writing | research | content
set -euo pipefail

INSTALL_CODEX=0
if [ "${1:-}" = "--install-codex" ]; then
  INSTALL_CODEX=1
  shift
fi

if [ $# -ne 3 ]; then
  echo "usage: $(basename "$0") [--install-codex] <domain> <skill-name> \"<one-line purpose>\"" >&2
  exit 2
fi

DOMAIN="$1"
NAME="$2"
PURPOSE="$3"

case "$DOMAIN" in
  infrastructure|automation|writing|research|content) ;;
  *) echo "error: invalid domain '$DOMAIN' (expected one of: infrastructure|automation|writing|research|content)" >&2; exit 2 ;;
esac

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(bash "$HERE/resolve-skill-repo.sh")"
TARGET="$REPO/skills/$DOMAIN/$NAME"

[ -e "$TARGET" ] && { echo "error: $TARGET already exists" >&2; exit 1; }

mkdir -p "$TARGET/references" "$TARGET/scripts"

cat > "$TARGET/SKILL.md" <<EOF
---
name: $NAME
description: >
  Use when … (fill in: trigger phrases, conditions; ≤ 500 chars).
metadata:
  author: minxian
  version: "0.1.0"
---

# $NAME

<one-paragraph overview: what this skill does and the problem it captures>

## When to use

<conditions / non-conditions>

## Workflow

\`\`\`text
[1] …
[2] …
\`\`\`

## Common pitfalls

| Mistake | Fix |
| ------- | --- |
|         |     |

## Verification

- [ ]
EOF

# Insert README row alphabetically inside the matching domain section.
python3 - "$REPO/README.md" "$DOMAIN" "$NAME" "$PURPOSE" <<'PY'
import pathlib, re, sys
readme = pathlib.Path(sys.argv[1])
domain, name, purpose = sys.argv[2], sys.argv[3], sys.argv[4]
text = readme.read_text()

# Domain heading is title-cased ("Automation", "Infrastructure", ...).
heading = domain.capitalize()
row = f"| [`{name}`](skills/{domain}/{name}/SKILL.md) | {purpose} |"

pat = re.compile(
    rf"(### {re.escape(heading)}\n.*?\| ----- \| ------- \|\n)((?:\|.*\n)*)",
    re.S,
)
m = pat.search(text)
if not m:
    sys.exit(f"error: domain table for '{heading}' not found in README.md")

rows = m.group(2).splitlines(keepends=True)
rows.append(row + "\n")
rows.sort(key=lambda l: (re.match(r"\| \[`([^`]+)`\]", l.strip()) or re.match(r"", "")).group(1)
                       if re.match(r"\| \[`([^`]+)`\]", l.strip()) else "")
new = m.group(1) + "".join(rows)
readme.write_text(text[:m.start()] + new + text[m.end():])
print(f"inserted README row under ### {heading}")
PY

cd "$REPO"
mkdir -p ".agent/skills" ".claude/skills"
ln -sf "../../skills/$DOMAIN/$NAME" ".agent/skills/$NAME"
ln -sf "../../skills/$DOMAIN/$NAME" ".claude/skills/$NAME"

git add "skills/$DOMAIN/$NAME" "README.md" ".agent/skills/$NAME" ".claude/skills/$NAME"

CODEX_LINK=""
if [ "$INSTALL_CODEX" -eq 1 ]; then
  CODEX_SKILLS_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
  mkdir -p "$CODEX_SKILLS_DIR"
  CODEX_LINK="$CODEX_SKILLS_DIR/$NAME"
  if [ -e "$CODEX_LINK" ] && [ ! -L "$CODEX_LINK" ]; then
    echo "warning: $CODEX_LINK exists and is not a symlink; leaving it untouched" >&2
  elif [ -L "$CODEX_LINK" ]; then
    rm "$CODEX_LINK"
    ln -s "$TARGET" "$CODEX_LINK"
  else
    ln -s "$TARGET" "$CODEX_LINK"
  fi
fi

cat <<EOF

scaffolded: $TARGET
github repo files: staged
codex local install: $([ "$INSTALL_CODEX" -eq 1 ] && echo "${CODEX_LINK:-skipped: existing non-symlink}" || echo "skipped")
next steps:
  1. fill in $TARGET/SKILL.md
  2. extract long code (≥ 15 lines) to scripts/, long config to references/
  3. bash "$HERE/publish-skill.sh" "$DOMAIN" "$NAME"
  4. if installed locally, start a fresh Codex session if the slash menu does not show the skill yet
EOF
