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
SKIPPED_SETTINGS=0

# A folder that already holds something is somebody's project. It gets the loop, not this
# package's own licence, README and example.
FRESH=1
[ -n "$(ls -A "$DEST" 2>/dev/null)" ] && FRESH=0

# The agent directory (.claude or .opencode) is merged file by file: a project that has one keeps
# what is in it, and the procedures and the hook of an earlier install are replaced by these.
# Only a settings.json that is already there is left alone, because it is the project's own.
merge_agent_dir() {
  local SRC="$1" TARGET="$DEST/$AGENT_DIR"
  mkdir -p "$TARGET"
  if [ -e "$TARGET/settings.json" ] && [ -e "$SRC/settings.json" ]; then
    SKIPPED_SETTINGS=1
  fi
  while IFS= read -r FILE; do
    if [ "$FILE" = "./settings.json" ] && [ "$SKIPPED_SETTINGS" = "1" ]; then
      continue
    fi
    mkdir -p "$TARGET/$(dirname "$FILE")"
    cp -p "$SRC/$FILE" "$TARGET/$FILE"
  done < <(cd "$SRC" && find . -type f | sort)
  if [ "$FRESH" = "1" ]; then
    echo "Installed: $AGENT_DIR"
  else
    echo "Installed into $AGENT_DIR: the nine procedures and the hook"
  fi
}

# Everything the assembly produced, dotfiles included — the agent directory is the part that
# matters and the leading dot is what makes it easy to lose.
while IFS= read -r SRC; do
  ITEM="$(basename "$SRC")"
  if [ "$ITEM" = "$AGENT_DIR" ]; then
    merge_agent_dir "$SRC"
  elif [ "$FRESH" = "0" ] && { [ "$ITEM" = "LICENSE" ] || [ "$ITEM" = "README.md" ] || [ "$ITEM" = "example-session-log.md" ]; }; then
    :
  elif [ -e "$DEST/$ITEM" ]; then
    echo "Already there, not overwritten: $ITEM"
    [ "$ITEM" = "$INSTRUCTIONS" ] && SKIPPED_INSTRUCTIONS=1
  else
    cp -R "$SRC" "$DEST/"
    echo "Installed: $ITEM"
  fi
done < <(find "$STAGE" -mindepth 1 -maxdepth 1 | sort)

echo
COUNT=$(find "$DEST/$AGENT_DIR/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
if [ "$COUNT" -ge 9 ]; then
  echo "All nine procedures are in place."
else
  echo "WARNING: expected nine procedures, found $COUNT — check $DEST/$AGENT_DIR/skills/"
  exit 1
fi

if [ "$SKIPPED_INSTRUCTIONS" = "1" ]; then
  echo
  echo "You already had a $INSTRUCTIONS, so yours was left alone. Add this to it, otherwise the"
  echo "agent will not know the loop is there:"
  echo
  echo "    This project uses Context Loop. Read context/rules.md at the start of every"
  echo "    session and follow it. Start with /session-start, end with /session-end."
fi

if [ "$SKIPPED_SETTINGS" = "1" ]; then
  echo
  echo "You already had $AGENT_DIR/settings.json, so yours was left alone. The session-start hook"
  echo "is installed but not wired up. To use it, add this under \"hooks\" in that file:"
  echo
  echo '    "SessionStart": [{"hooks": [{"type": "command",'
  echo '      "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-context.sh"}]}]'
  echo
  echo "Without it the loop works the same; /session-start reads the files itself."
fi

echo
echo "Next:"
echo "  cd $DEST"
echo "  git init          # optional, but the loop is better with a history"
echo "  $LAUNCH"
echo "  /session-start"
