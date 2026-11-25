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

# A project without context/ does not use the loop, or has not started yet. Either way there is
# nothing to report: installed as a plugin, this hook runs in every project the user opens.
[ -d "$ROOT/context" ] || exit 0

# --- Topics currently claimed ----------------------------------------------
ACTIVE="$ROOT/context/session-active.md"
if [ -f "$ACTIVE" ]; then
  # The first two table lines are the header and its rule, in whatever language the project uses.
  ROWS=$(grep '^|' "$ACTIVE" 2>/dev/null | tail -n +3 || true)
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
# The date is in the filename, so no file has to be opened. How many days may pass is the
# project's own rule: audit-interval-days in context/rules.md, 14 when the file or the line is
# missing. No audit yet is reported once per start, as a fact, once the project is older than the
# interval — the first run starts the clock.
#
# The age is worked out with date(1) alone, GNU form first, BSD form second. Where neither
# works, the line is left out: /session-start works the same thing out from the files.
RULES="$ROOT/context/rules.md"
INTERVAL=""
[ -f "$RULES" ] && INTERVAL=$(grep -m1 -E '^audit-interval-days:' "$RULES" 2>/dev/null | tr -dc '0-9')
[ -z "$INTERVAL" ] && INTERVAL=14

epoch() {
  date -d "$1" +%s 2>/dev/null || date -j -f "%Y-%m-%d %H:%M:%S" "$1 00:00:00" +%s 2>/dev/null
}

AUDITS="$ROOT/context/audits"
MISSING=""
NOW=$(epoch "$(date +%Y-%m-%d)")
for KIND in security-audit doc-audit; do
  LATEST=$(ls -1 "$AUDITS" 2>/dev/null | grep -- "_$KIND\.md$" | sort | tail -1)
  if [ -z "$LATEST" ]; then
    MISSING+=" /$KIND"
    continue
  fi
  DATE="${LATEST%%_*}"
  THEN=$(epoch "$DATE")
  DAYS=""
  [ -n "$NOW" ] && [ -n "$THEN" ] && DAYS=$(( (NOW - THEN + 43200) / 86400 ))   # +12h: a clock change must not eat a day
  if [ -n "$DAYS" ] && [ "$DAYS" -ge "$INTERVAL" ]; then
    OUT+="AUDIT DUE: last $KIND was $DAYS days ago ($DATE). Run /$KIND."$'\n'
  fi
done
# A project younger than the interval has nothing to audit yet, and "none run" on day one reads
# like a warning. Its age is the date of its oldest session log; no log yet means it is new.
if [ -n "$MISSING" ]; then
  FIRST=$(ls -1 "$ROOT/context/session-logs" 2>/dev/null | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}_' | sort | head -1)
  AGE=""
  if [ -n "$FIRST" ] && [ -n "$NOW" ]; then
    BORN=$(epoch "${FIRST%%_*}")
    [ -n "$BORN" ] && AGE=$(( (NOW - BORN + 43200) / 86400 ))
  fi
  if [ -n "$AGE" ] && [ "$AGE" -ge "$INTERVAL" ]; then
    OUT+="AUDITS: none run yet. Start the $INTERVAL-day cadence with:$MISSING"$'\n'
  fi
fi

[ -z "$OUT" ] && OUT="State clean: nothing claimed, nothing uncommitted, audits current."

if [ "$PLAIN" = "1" ]; then
  printf '%s\n' "$OUT"
  exit 0
fi

# The JSON envelope is built here rather than by a helper program, so the hook needs nothing but
# a shell: backslashes and quotes escaped, tabs turned into spaces, line ends into \n.
ESC=$(printf '%s' "$OUT" | tr '\t' ' ' | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | awk 'BEGIN{ORS="\\n"} {print}')
ESC="${ESC%\\n}"
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$ESC"

exit 0
