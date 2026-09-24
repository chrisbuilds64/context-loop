#!/bin/bash
# Context Loop — install into a project folder from a checkout of this repository.
#
# For people who already have a shell and this repo. The download ships the double-click
# installer instead.
#
# Usage:  install/install.sh /path/to/your/project
#         install/install.sh            (installs into the current directory)

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
DEST="${1:-$(pwd)}"

if [ "$ROOT" = "$DEST" ]; then
  echo "That is the repository itself. Give me a target:"
  echo "  install/install.sh /path/to/your/project"
  exit 1
fi

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
"$HERE/assemble.sh" "$STAGE"

mkdir -p "$DEST"
SKIPPED_CLAUDE_MD=0

for ITEM in .claude .gitignore context CLAUDE.md README.md LICENSE example-session-log.md; do
  if [ -e "$DEST/$ITEM" ]; then
    echo "Already there, not overwritten: $ITEM"
    [ "$ITEM" = "CLAUDE.md" ] && SKIPPED_CLAUDE_MD=1
  else
    cp -R "$STAGE/$ITEM" "$DEST/"
    echo "Installed: $ITEM"
  fi
done

echo
COUNT=$(ls -1 "$DEST/.claude/skills" 2>/dev/null | wc -l | tr -d ' ')
if [ "$COUNT" = "9" ]; then
  echo "All nine skills are in place."
else
  echo "WARNING: expected nine skills, found $COUNT — check $DEST/.claude/skills/"
  exit 1
fi

if [ "$SKIPPED_CLAUDE_MD" = "1" ]; then
  echo
  echo "You already had a CLAUDE.md, so yours was left alone. Add these two lines to it,"
  echo "otherwise the agent will not know to run the loop:"
  echo
  echo "    ## Every session"
  echo "    Start with /session-start. End with /session-end."
fi

echo
echo "Next:"
echo "  cd $DEST"
echo "  git init          # optional, but the loop is better with a history"
echo "  claude"
echo "  /session-start"
