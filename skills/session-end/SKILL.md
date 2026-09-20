---
name: session-end
description: Close the current session. Writes a session log ending in a Continuation Thread, records the decisions, updates PROJECT-STATE.md, releases the topic in session-active.md, and commits. Use at the end of every working session.
disable-model-invocation: true
argument-hint: "[optional: slug for the session log filename]"
---

# Session End

You are closing a working session. Work through the steps in order.

**This is the step that makes the whole loop work.** A session that is not closed leaves the
next one with nothing to read.

## Step 1: Collect

From this conversation: today's date, which agent worked, which topic was declared. If any of
it is missing, look at the beginning of the conversation before asking.

## Step 2: Summarise

Go through the whole conversation and pull out: what was finished, what was decided, what broke,
what is still open, which commits were made. Factual, grouped by subject, no padding.

## Step 3: Write the session log

Create `context/session-logs/<YYYY-MM-DD>_<slug>.md`. Use the slug from the argument if there is
one, otherwise derive it from the main subject. Lowercase, hyphens, underscore after the date.

The date leads so the age of a file is visible in its name.

```markdown
# Session <YYYY-MM-DD> — <title>

**Date:** <date>
**Agent:** <name>
**Topic:** <topic>

---

## What happened

<grouped summary>

---

## Decisions

<only if there were any — otherwise leave the section out>

---

## Open

- [ ] <what is still open>

---

## Commits

- `<hash>` <message>

---

## Continuation Thread

**Still open:** <what remains unresolved — as a problem, not as a task. What would come back up
first in the next session?>

**Next natural sentence:** <how the next session would begin if there had been no break. One
concrete sentence, not a subject.>

**Energy:** <was this productive, frustrating, exploratory? Briefly why, and what that means for
the next start.>
```

**The Continuation Thread is mandatory.** Not optional when the session was short.

Three rules for it:

- It is not a repeat of "Open" above. That is the task list; this is the thread of the
  conversation.
- "Next natural sentence" is a sentence. Not "we should look at the config" but "do we fix the
  config before or after the release?"
- Three to five sentences in total. Density beats completeness — a thread nobody reads carries
  nothing.

## Step 3b: Record the decisions

For every entry under Decisions in the log, append one entry to `context/decisions.md`:

```
## <YYYY-MM-DD> — <what was decided, one line>
**Why:** <the reason>
**Instead of:** <the rejected alternative, if there was one>
```

Append only. Never edit an earlier entry — if a decision is reversed, that is a new entry that
says so. The log is where it happened; this file is where it can be found.

## Step 4: Update the state

In `context/PROJECT-STATE.md`: update the date at the top, move finished items out of the
working section, add anything new that came up, and keep the "Done" section to the last two
sessions. Older ones live in the session logs.

**PROJECT-STATE is state, not history.** It holds the current value, and it gets overwritten.
The history is in the logs and in git. Never version this file — a second numbered copy beside
it claims an alternative that does not exist.

## Step 5: Release the topic

Remove this session's row from `context/session-active.md`. Leave the header.

## Step 6: Commit

```bash
git add context/
git commit -m "session <YYYY-MM-DD>: <topic>"
```

Check `git status` first and do not commit if nothing changed. Never commit secrets, `.env`
files or credentials.

## Step 7: Report

Short: the name of the session log, what was committed, anything still open that carries a date.

## Step 8: Label

As the very last output, print the session log filename without path or extension, in a code
block, so it can be copied to name the conversation:

```
2026-01-15_first-session
```

No explanation. Just the label.

**This applies even when this skill was not used.** A session closed by hand still needs its
label at the end of the last message.

---

## Rules

- No emoji unless asked for.
- Do not commit if there is nothing to commit.
- Do not push a branch that has diverged — say so instead.
- The Continuation Thread is written last and is never skipped.
