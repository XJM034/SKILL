#!/usr/bin/env bash
# Create a draft post on mx-space from a LiteXML envelope, mark it as
# AI-written (aiGen=2), open the admin edit page for the user to preview,
# and silence the full server response. Does NOT publish — run
# `mxs post publish <slug> --profile railway-mx-space` after approval.
#
# Usage: publish-post.sh <article.xml>
set -euo pipefail

CODEX_DIR="${CODEX_DIR:-$HOME/.codex}"
[ -d "$CODEX_DIR/node_modules/.bin" ] && PATH="$CODEX_DIR/node_modules/.bin:$PATH"
if [ -f "$CODEX_DIR/config/innei-skills/mxs.env" ]; then
  set -a
  . "$CODEX_DIR/config/innei-skills/mxs.env"
  set +a
fi

if [ $# -ne 1 ]; then
  echo "usage: $(basename "$0") <article.xml>" >&2
  exit 2
fi

SRC="$1"
[ -f "$SRC" ] || { echo "error: $SRC not found" >&2; exit 1; }

mxs post create --file "$SRC" --meta '{"aiGen":2}' --open --silent
