#!/bin/bash
# Assemble an installable pack from this repository into a directory.
#
# The repository keeps each piece once: the procedures in skills/, the hook in hooks/, the
# project's instruction files in template/, the per-environment wiring in adapters/ — and the
# state a project starts with inside skills/session-start/scaffold/, because that skill creates it
# on a first run and a skill can only reach its own directory. An installed project wants all of
# it arranged differently, and differently again depending on where the agent runs. This script is
# the only place those mappings exist, because two copies of an assembly drift and nobody notices
# until a download is missing a piece.
#
#   assemble.sh <dir>              Claude Code: skills and hook under .claude/
#   assemble.sh <dir> --app        Claude apps: no .claude/, the procedures as plain files in loop/
#   assemble.sh <dir> --opencode   OpenCode: skills and commands under .opencode/, AGENTS.md
#
# The app layout exists because Cowork and the other app surfaces do not read .claude/. They read
# the folder and the standing instructions of the project — so the loop travels as files and a
# paragraph, which is what it was all along.
#
# The OpenCode layout exists because OpenCode finds the skills by itself but does not offer them
# in the slash menu — that menu lists commands. So each procedure gets a three-line command that
# calls its skill, the instruction file is called AGENTS.md there, and /session-start additionally
# embeds the state, because OpenCode has no session-start event.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:?usage: assemble.sh <target directory> [--app|--opencode]}"
MODE="${2:-claude-code}"

mkdir -p "$OUT"

strip_frontmatter() {
  awk 'NR==1 && /^---$/ {fm=1; next} fm==1 && /^---$/ {fm=2; next} fm!=1 {print}' "$1"
}

cp -R "$ROOT/skills/session-start/scaffold" "$OUT/context"
cp "$ROOT/template/example-session-log.md" "$OUT/"
cp "$ROOT/LICENSE" "$OUT/LICENSE"

case "$MODE" in
--app)
  # --- Claude apps -----------------------------------------------------------
  mkdir -p "$OUT/loop"
  for SKILL in "$ROOT"/skills/*/; do
    NAME="$(basename "$SKILL")"
    strip_frontmatter "$SKILL/SKILL.md" > "$OUT/loop/$NAME.md"
  done
  cp "$ROOT/template/project-instructions.txt" "$OUT/"
  cp "$ROOT/template/README-app.md" "$OUT/README.md"

  COUNT=$(ls -1 "$OUT/loop" | wc -l | tr -d ' ')
  [ "$COUNT" = "9" ] || { echo "assemble: expected 9 procedures, found $COUNT" >&2; exit 1; }
  ;;

--opencode)
  # --- OpenCode --------------------------------------------------------------
  # Skills go under .opencode/ rather than .claude/: OpenCode reads both, but a project that is
  # only ever opened in OpenCode should not carry another tool's directory.
  mkdir -p "$OUT/.opencode"
  cp -R "$ROOT/skills" "$OUT/.opencode/skills"
  cp -R "$ROOT/adapters/opencode/commands" "$OUT/.opencode/commands"
  cp "$ROOT/hooks/session-context.sh" "$OUT/.opencode/session-context.sh"
  cp "$ROOT/adapters/opencode/opencode.json" "$OUT/opencode.json"
  cp "$ROOT/template/CLAUDE.md" "$OUT/AGENTS.md"
  cp "$ROOT/template/.gitignore" "$OUT/.gitignore"
  cp "$ROOT/template/README-opencode.md" "$OUT/README.md"
  chmod +x "$OUT/.opencode/session-context.sh"

  COUNT=$(ls -1 "$OUT/.opencode/skills" | wc -l | tr -d ' ')
  [ "$COUNT" = "9" ] || { echo "assemble: expected 9 skills, found $COUNT" >&2; exit 1; }
  CMDS=$(ls -1 "$OUT/.opencode/commands" | wc -l | tr -d ' ')
  [ "$CMDS" = "9" ] || { echo "assemble: expected 9 commands, found $CMDS" >&2; exit 1; }
  ;;

*)
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
  [ "$COUNT" = "9" ] || { echo "assemble: expected 9 skills, found $COUNT" >&2; exit 1; }
  ;;
esac

find "$OUT" -name '.DS_Store' -delete 2>/dev/null || true
find "$OUT" -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true
