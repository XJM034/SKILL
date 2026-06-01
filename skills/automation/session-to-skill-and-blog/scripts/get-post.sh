#!/usr/bin/env bash
# Round-trip step 1: fetch an existing post as XML so it can be edited
# locally. Prints to stdout.
#
# Usage: get-post.sh <slug> > /tmp/blog/article.xml
set -euo pipefail

CODEX_DIR="${CODEX_DIR:-$HOME/.codex}"
[ -d "$CODEX_DIR/node_modules/.bin" ] && PATH="$CODEX_DIR/node_modules/.bin:$PATH"
if [ -f "$CODEX_DIR/config/innei-skills/mxs.env" ]; then
  set -a
  . "$CODEX_DIR/config/innei-skills/mxs.env"
  set +a
fi

if [ $# -ne 1 ]; then
  echo "usage: $(basename "$0") <slug>" >&2
  exit 2
fi

mxs post get "$1" --output xml
