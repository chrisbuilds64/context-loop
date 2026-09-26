#!/bin/bash
# SessionStart hook — puts the operational state in front of the agent before the first word.
#
# It exists because three things go unnoticed otherwise: a topic still claimed by a session that
# never closed, work sitting uncommitted, and an audit that quietly slipped past its date.
#
# It reports, it does not interpret. "5 uncommitted files" is a fact; "your last session failed"
# is a guess, and on a fresh install it is a wrong one.
#
# A SessionStart hook cannot block and cannot force anything. It can only add context, which is
# the right shape here: state the facts and let the session act on them.
#
# Output contract: JSON on stdout, exit 0. This script never fails hard — a broken hook must not
# stop a session from starting.
#
# With --plain it prints the same text without the JSON envelope. That is the OpenCode route:
# there is no session-start event there, so the /session-start command embeds this output in its
# template instead. One script, two output forms — the logic is not worth having twice.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PLAIN=0
[ "${1:-}" = "--plain" ] && PLAIN=1
OUT=""

# --- Topics currently claimed ----------------------------------------------
ACTIVE="$ROOT/context/session-active.md"
if [ -f "$ACTIVE" ]; then
  ROWS=$(grep '^|' "$ACTIVE" 2>/dev/null | grep -v '^| Topic' | grep -v '^|--' || true)
  if [ -n "$ROWS" ]; then
    OUT+="TOPICS CLAIMED (another session may be running, or one ended without /session-end):"$'\n'
    OUT+="$ROWS"$'\n\n'
  fi
fi

# --- Uncommitted work -------------------------------------------------------
if [ -d "$ROOT/.git" ]; then
  COUNT=$(git -C "$ROOT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$COUNT" != "0" ]; then
    [ "$COUNT" = "1" ] && NOUN="file" || NOUN="files"
    OUT+="UNCOMMITTED: $COUNT changed $NOUN."$'\n\n'
  fi
fi

# --- Audit age --------------------------------------------------------------
# The date is in the filename, so no file has to be opened. 14 days is the cadence both audit
# skills assume. No audit yet is reported once per start, as a fact — the first run starts the
# clock.
AUDITS="$ROOT/context/audits"
MISSING=""
for KIND in security-audit doc-audit; do
  LATEST=$(ls -1 "$AUDITS" 2>/dev/null | grep -- "_$KIND\.md$" | sort | tail -1)
  if [ -z "$LATEST" ]; then
    MISSING+=" /$KIND"
    continue
  fi
  DATE="${LATEST%%_*}"
  DAYS=$(python3 -c 'import sys, datetime; print((datetime.date.today() - datetime.date.fromisoformat(sys.argv[1])).days)' "$DATE" 2>/dev/null || echo "")
  if [ -n "$DAYS" ] && [ "$DAYS" -ge 14 ]; then
    OUT+="AUDIT DUE: last $KIND was $DAYS days ago ($DATE). Run /$KIND."$'\n'
  fi
done
[ -n "$MISSING" ] && OUT+="AUDITS: none run yet. Start the 14-day cadence with:$MISSING"$'\n'

[ -z "$OUT" ] && OUT="State clean: nothing claimed, nothing uncommitted, audits current."

if [ "$PLAIN" = "1" ]; then
  printf '%s\n' "$OUT"
  exit 0
fi

python3 -c '
import json, sys
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": sys.stdin.read().rstrip()
    }
}))' <<< "$OUT"

exit 0
