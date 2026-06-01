#!/usr/bin/env bash
# Print the absolute path to the SKILL repo.
# Reads `skill_repo_dir` from ~/.config/innei-skills/config.json; falls back to
# ~/git/innei-repo/skill. Expands a leading ~ to $HOME.
set -euo pipefail

CODEX_DIR="${CODEX_DIR:-$HOME/.codex}"
CODEX_CFG="$CODEX_DIR/config/innei-skills/config.json"
CFG="${INNEI_SKILLS_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/innei-skills/config.json}"
[ -f "$CFG" ] || CFG="$CODEX_CFG"
DIR=""
if [ -n "${INNEI_SKILL_REPO_DIR:-}" ]; then
  DIR="$INNEI_SKILL_REPO_DIR"
elif [ -f "$CFG" ] && command -v jq >/dev/null 2>&1; then
  DIR="$(jq -r '.skill_repo_dir // empty' "$CFG" 2>/dev/null || true)"
fi
DIR="${DIR:-$CODEX_DIR/skill-first-assets}"
DIR="${DIR/#\~/$HOME}"
echo "$DIR"
