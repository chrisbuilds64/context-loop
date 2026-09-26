#!/bin/bash
# Context Loop — install into a project folder from a checkout of this repository.
#
# For people who already have a shell and this repo. The download ships the double-click
# installer instead.
#
# Usage:  install/install.sh /path/to/your/project
#         install/install.sh /path/to/your/project --opencode
#         install/install.sh            (installs into the current directory, for Claude Code)

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
DEST="${1:-$(pwd)}"
MODE="${2:-claude-code}"

if [ "$ROOT" = "$DEST" ]; then
  echo "That is the repository itself. Give me a target:"
  echo "  install/install.sh /path/to/your/project"
  exit 1
fi

case "$MODE" in
--opencode) AGENT_DIR=".opencode"; INSTRUCTIONS="AGENTS.md"; LAUNCH="opencode" ;;
claude-code) AGENT_DIR=".claude";  INSTRUCTIONS="CLAUDE.md"; LAUNCH="claude"   ;;
*) echo "Unknown mode: $MODE (expected --opencode)" >&2; exit 1 ;;
esac

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
"$HERE/assemble.sh" "$STAGE" "$MODE"

mkdir -p "$DEST"
SKIPPED_INSTRUCTIONS=0

# Everything the assembly produced, dotfiles included — the agent directory is the part that
# matters and the leading dot is what makes it easy to lose.
while IFS= read -r SRC; do
  ITEM="$(basename "$SRC")"
  if [ -e "$DEST/$ITEM" ]; then
    echo "Already there, not overwritten: $ITEM"
    [ "$ITEM" = "$INSTRUCTIONS" ] && SKIPPED_INSTRUCTIONS=1
  else
    cp -R "$SRC" "$DEST/"
    echo "Installed: $ITEM"
  fi
done < <(find "$STAGE" -mindepth 1 -maxdepth 1 | sort)

echo
COUNT=$(ls -1 "$DEST/$AGENT_DIR/skills" 2>/dev/null | wc -l | tr -d ' ')
if [ "$COUNT" = "9" ]; then
  echo "All nine procedures are in place."
else
  echo "WARNING: expected nine procedures, found $COUNT — check $DEST/$AGENT_DIR/skills/"
  exit 1
fi

if [ "$SKIPPED_INSTRUCTIONS" = "1" ]; then
  echo
  echo "You already had a $INSTRUCTIONS, so yours was left alone. Add these two lines to it,"
  echo "otherwise the agent will not know to run the loop:"
  echo
  echo "    ## Every session"
  echo "    Start with /session-start. End with /session-end."
fi

echo
echo "Next:"
echo "  cd $DEST"
echo "  git init          # optional, but the loop is better with a history"
echo "  $LAUNCH"
echo "  /session-start"
