#!/bin/bash
# Assemble an installable pack from this repository into a directory.
#
# The repository keeps each piece once: the skills in skills/, the hook in hooks/, everything a
# project starts with in template/. An installed project wants them arranged differently — and
# differently again depending on where the agent runs. This script is the only place those
# mappings exist, because two copies of an assembly drift and nobody notices until a download is
# missing a piece.
#
#   assemble.sh <dir>          Claude Code: skills and hook under .claude/
#   assemble.sh <dir> --app    Claude apps: no .claude/, the procedures as plain files in loop/
#
# The app layout exists because Cowork and the other app surfaces do not read .claude/. They read
# the folder and the standing instructions of the project — so the loop travels as files and a
# paragraph, which is what it was all along.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:?usage: assemble.sh <target directory> [--app]}"
MODE="${2:-claude-code}"

mkdir -p "$OUT"
cp -R "$ROOT/template/context" "$OUT/context"
cp "$ROOT/template/example-session-log.md" "$OUT/"
cp "$ROOT/LICENSE" "$OUT/LICENSE"

strip_frontmatter() {
  awk 'NR==1 && /^---$/ {fm=1; next} fm==1 && /^---$/ {fm=2; next} fm!=1 {print}' "$1"
}

if [ "$MODE" = "--app" ]; then
  # --- Claude apps -----------------------------------------------------------
  mkdir -p "$OUT/loop"
  for SKILL in "$ROOT"/skills/*/; do
    NAME="$(basename "$SKILL")"
    strip_frontmatter "$SKILL/SKILL.md" > "$OUT/loop/$NAME.md"
  done
  cp "$ROOT/template/project-instructions.txt" "$OUT/"
  cp "$ROOT/template/README-app.md" "$OUT/README.md"

  COUNT=$(ls -1 "$OUT/loop" | wc -l | tr -d ' ')
  [ "$COUNT" = "5" ] || { echo "assemble: expected 5 procedures, found $COUNT" >&2; exit 1; }
else
  # --- Claude Code -----------------------------------------------------------
  mkdir -p "$OUT/.claude/hooks"
  cp -R "$ROOT/skills" "$OUT/.claude/skills"
  cp "$ROOT/hooks/session-context.sh" "$OUT/.claude/hooks/session-context.sh"
  cp "$ROOT/install/settings.json" "$OUT/.claude/settings.json"
  cp "$ROOT/template/CLAUDE.md" "$OUT/CLAUDE.md"
  cp "$ROOT/template/.gitignore" "$OUT/.gitignore"
  cp "$ROOT/template/README.md" "$OUT/README.md"
  chmod +x "$OUT/.claude/hooks/session-context.sh"

  COUNT=$(ls -1 "$OUT/.claude/skills" | wc -l | tr -d ' ')
  [ "$COUNT" = "5" ] || { echo "assemble: expected 5 skills, found $COUNT" >&2; exit 1; }
fi

find "$OUT" -name '.DS_Store' -delete 2>/dev/null || true
