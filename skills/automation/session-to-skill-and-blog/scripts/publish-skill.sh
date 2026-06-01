#!/usr/bin/env bash
# Commit, push, and verify a skill in the configured GitHub-backed SKILL repo.
#
# Usage: publish-skill.sh <domain> <skill-name> ["commit message"]
set -euo pipefail

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "usage: $(basename "$0") <domain> <skill-name> [\"commit message\"]" >&2
  exit 2
fi

DOMAIN="$1"
NAME="$2"
MESSAGE="${3:-feat: add $NAME skill}"

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(bash "$HERE/resolve-skill-repo.sh")"
TARGET="$REPO/skills/$DOMAIN/$NAME"

[ -f "$TARGET/SKILL.md" ] || { echo "error: $TARGET/SKILL.md not found" >&2; exit 1; }

PUBLIC_BASE="$(
  python3 - <<'PY'
import json, os, pathlib

paths = [
    pathlib.Path.home() / ".codex/config/innei-skills/config.json",
    pathlib.Path.home() / ".config/innei-skills/config.json",
]
for path in paths:
    if path.exists():
        try:
            value = json.loads(path.read_text()).get("skill_repo_public_url")
        except Exception:
            value = None
        if value:
            print(value.rstrip("/"))
            raise SystemExit(0)

print("https://github.com/XJM034/SKILL/tree/main")
PY
)"

SKILL_URL="$PUBLIC_BASE/skills/$DOMAIN/$NAME"

cd "$REPO"

paths=("skills/$DOMAIN/$NAME" "README.md" ".agent/skills/$NAME" ".claude/skills/$NAME")
git add "${paths[@]}"

if ! git diff --cached --quiet -- "${paths[@]}"; then
  git commit -m "$MESSAGE" -- "${paths[@]}"
else
  echo "no staged skill changes to commit"
fi

git push

if command -v curl >/dev/null 2>&1; then
  curl -fsSIL "$SKILL_URL" >/dev/null
  echo "verified: $SKILL_URL"
else
  echo "warning: curl not found; skipped URL verification: $SKILL_URL" >&2
fi

echo "skill_url=$SKILL_URL"
