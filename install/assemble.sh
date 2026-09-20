#!/bin/bash
# Assemble a complete, installable pack from this repository into a directory.
#
# The repository keeps each piece once: the skills in skills/, the hook in hooks/, everything a
# project starts with in template/. An installed project wants them in one folder with the
# .claude layout. This script is the only place that mapping exists — build-zip.sh and
# install.sh both call it, because two copies of an assembly drift and nobody notices until a
# download is missing a skill.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:?usage: assemble.sh <target directory>}"

mkdir -p "$OUT/.claude/hooks"

cp -R "$ROOT/template/." "$OUT/"
cp -R "$ROOT/skills" "$OUT/.claude/skills"
cp "$ROOT/hooks/session-context.sh" "$OUT/.claude/hooks/session-context.sh"
cp "$ROOT/install/settings.json" "$OUT/.claude/settings.json"
cp "$ROOT/LICENSE" "$OUT/LICENSE"

chmod +x "$OUT/.claude/hooks/session-context.sh"
find "$OUT" -name '.DS_Store' -delete 2>/dev/null || true

COUNT=$(ls -1 "$OUT/.claude/skills" | wc -l | tr -d ' ')
[ "$COUNT" = "5" ] || { echo "assemble: expected 5 skills, found $COUNT" >&2; exit 1; }
