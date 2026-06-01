#!/usr/bin/env bash
# Fetch the latest `litexml-authoring` skill subtree from
# github.com/Innei/haklex/.claude/skills/litexml-authoring via degit.
# Always overwrites the cache. Prints the cache path on stdout.
#
# Usage: load-litexml.sh                # fetch + print path
#        LITEXML_CACHE=$(load-litexml.sh)
set -euo pipefail

CODEX_DIR="${CODEX_DIR:-$HOME/.codex}"
[ -d "$CODEX_DIR/node_modules/.bin" ] && PATH="$CODEX_DIR/node_modules/.bin:$PATH"

CACHE="${XDG_CACHE_HOME:-$CODEX_DIR/cache}/innei-skills/litexml-authoring"
mkdir -p "$(dirname "$CACHE")"

if command -v degit >/dev/null 2>&1; then
  DEGIT_CMD=(degit)
else
  DEGIT_CMD=(npx -y degit)
fi

if ! "${DEGIT_CMD[@]}" Innei/haklex/.claude/skills/litexml-authoring "$CACHE" --force >&2; then
  if [ -d "$CACHE" ]; then
    echo "warning: degit fetch failed; using stale cache" >&2
  else
    echo "error: degit fetch failed and no cache available" >&2
    exit 1
  fi
fi

echo "$CACHE"
