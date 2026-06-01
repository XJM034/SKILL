#!/usr/bin/env bash
# Round-trip step 2: PATCH an existing post from an edited XML file.
# Opens the admin edit page after success; silences the response body.
#
# Usage: update-post.sh <slug> <article.xml>
set -euo pipefail

CODEX_DIR="${CODEX_DIR:-$HOME/.codex}"
[ -d "$CODEX_DIR/node_modules/.bin" ] && PATH="$CODEX_DIR/node_modules/.bin:$PATH"
if [ -f "$CODEX_DIR/config/innei-skills/mxs.env" ]; then
  set -a
  . "$CODEX_DIR/config/innei-skills/mxs.env"
  set +a
fi

if [ $# -ne 2 ]; then
  echo "usage: $(basename "$0") <slug> <article.xml>" >&2
  exit 2
fi

SLUG="$1"
SRC="$2"
[ -f "$SRC" ] || { echo "error: $SRC not found" >&2; exit 1; }

mxs post update "$SLUG" --file "$SRC" --open --silent
