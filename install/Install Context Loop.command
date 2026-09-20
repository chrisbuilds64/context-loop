#!/bin/bash
# Context Loop — macOS installer.
#
# Double-click this file. It asks where to put the project, creates the folder and installs
# the pack into it.
#
# It exists because the most important part of the pack is the .claude directory, and a leading
# dot makes it invisible in Finder. Copying by hand leaves the skills and the hook behind, and
# nothing warns you — the folder looks complete and /session-start does not exist.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/pack"

printf '\n  Context Loop\n'
printf '  Your work carries from one agent session to the next, in files you own.\n\n'

if [ ! -d "$SRC/.claude/skills" ]; then
  printf '  The pack folder is missing next to this installer.\n'
  printf '  Unzip the whole download and keep the files together, then run this again.\n\n'
  read -n 1 -s -r -p '  Press any key to close.'
  exit 1
fi

# --- Where? ----------------------------------------------------------------
# A path can be passed as an argument; otherwise ask, with the native folder picker first.
PARENT="${1:-}"

if [ -z "$PARENT" ]; then
  printf '  Pick the folder to create the project in.\n'
  printf '  (A dialog should open. If it does not, type a path here instead.)\n\n'
  PARENT=$(osascript -e 'POSIX path of (choose folder with prompt "Where should Context Loop go?")' 2>/dev/null || true)
fi

if [ -z "$PARENT" ]; then
  read -e -r -p '  Folder: ' PARENT
  PARENT="${PARENT/#\~/$HOME}"
fi

PARENT="${PARENT%/}"

if [ ! -d "$PARENT" ]; then
  printf '\n  There is no folder at: %s\n\n' "$PARENT"
  read -n 1 -s -r -p '  Press any key to close.'
  exit 1
fi

# --- What should it be called? ---------------------------------------------
printf '\n  Name for the project folder [ContextLoop]: '
read -r NAME
NAME="${NAME:-ContextLoop}"
DEST="$PARENT/$NAME"

if [ -e "$DEST" ] && [ -n "$(ls -A "$DEST" 2>/dev/null)" ]; then
  printf '\n  %s already exists and is not empty.\n' "$DEST"
  printf '  Nothing that is already there will be overwritten.\n'
  printf '  Continue? [y/N]: '
  read -r GO
  case "$GO" in [yY]*) ;; *) printf '\n  Stopped. Nothing was changed.\n\n'; read -n 1 -s -r -p '  Press any key to close.'; exit 0 ;; esac
fi

mkdir -p "$DEST" || { printf '\n  Could not create %s\n\n' "$DEST"; read -n 1 -s -r -p '  Press any key to close.'; exit 1; }

# --- Install ---------------------------------------------------------------
printf '\n'
SKIPPED_CLAUDE_MD=0
for ITEM in .claude .gitignore context CLAUDE.md README.md LICENSE example-session-log.md; do
  if [ -e "$DEST/$ITEM" ]; then
    printf '  kept (already there)   %s\n' "$ITEM"
    [ "$ITEM" = "CLAUDE.md" ] && SKIPPED_CLAUDE_MD=1
  else
    cp -R "$SRC/$ITEM" "$DEST/" && printf '  installed              %s\n' "$ITEM"
  fi
done
find "$DEST" -name '.DS_Store' -delete 2>/dev/null

# --- Verify ----------------------------------------------------------------
printf '\n'
SKILLCOUNT=$(ls -1 "$DEST/.claude/skills" 2>/dev/null | wc -l | tr -d ' ')
if [ "$SKILLCOUNT" = "5" ]; then
  printf '  All five skills are in place.\n'
else
  printf '  SOMETHING WENT WRONG: expected five skills, found %s.\n' "$SKILLCOUNT"
  printf '  Look in %s/.claude/skills/\n\n' "$DEST"
  read -n 1 -s -r -p '  Press any key to close.'
  exit 1
fi

# --- Optional git ----------------------------------------------------------
if [ ! -d "$DEST/.git" ] && command -v git >/dev/null 2>&1; then
  printf '\n  Start a git history here? The loop works without it,\n'
  printf '  but the history is half of why the files are worth having. [Y/n]: '
  read -r DOGIT
  case "$DOGIT" in
    [nN]*) ;;
    *) (cd "$DEST" && git init -q . && git add -A && git -c user.email=you@example.com -c user.name="Context Loop" commit -q -m "context loop installed") && printf '  Git history started.\n' ;;
  esac
fi

if [ "$SKIPPED_CLAUDE_MD" = "1" ]; then
  printf '\n  You already had a CLAUDE.md, so yours was left alone.\n'
  printf '  Add these two lines to it, or the agent will not know to run the loop:\n\n'
  printf '      ## Every session\n'
  printf '      Start with /session-start. End with /session-end.\n'
fi

# --- What now? -------------------------------------------------------------
printf '\n  Installed in:\n    %s\n' "$DEST"
printf '\n  Next:\n'
printf '    1. Open a terminal there and run:  claude\n'
printf '    2. Type:  /session-start\n'
printf '    3. Do some work, then:  /session-end\n'
printf '\n  Then open the log it wrote in context/session-logs/ and read the last section.\n'
printf '  That is the part that makes the next session start where this one stopped.\n\n'

printf '  Open the folder now? [Y/n]: '
read -r OPENIT
case "$OPENIT" in [nN]*) ;; *) open "$DEST" ;; esac

printf '\n'
read -n 1 -s -r -p '  Press any key to close.'
printf '\n'
