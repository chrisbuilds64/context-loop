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

## Step 0: Read the rules

Read `context/rules.md` if you have not read it in this session. It says what a session log
contains, what goes into the project state, how decisions are kept, and which steps of your own
this project runs at the close. **Where it differs from this procedure, the rules win.** Its
`language:` setting is the language everything in this procedure is written in; section and field
names given here in English may stand in that language in the project. Match them by meaning.

If the file does not exist, this project was set up before the rules had a file of their own.
Say so in one line, close the session in the default shape (a log with What happened, Decisions,
Open, Commits and a Continuation Thread; decisions appended to `context/decisions.md`; the state
overwritten, not versioned), and tell the user that the next `/session-start` creates the file.

## Step 1: Collect

From this conversation: today's date, which agent worked, which topic was declared. If any of
it is missing, look at the beginning of the conversation before asking.

## Step 2: Summarise

Go through the whole conversation and pull out what the rules ask a session log to hold.

## Step 3: Write the session log

Create the file in the place, under the name and in the shape given in the rules, section
"What goes into a session log". Use the slug from the argument if there is one, otherwise derive
it from the main subject. Lowercase, hyphens, underscore after the date.

**The handover at the end of the log is written last and is never skipped.** It is what the next
session begins with.

## Step 3b: Record the decisions

For every decision in the log, append one entry to `context/decisions.md`, in the form given in
the rules, section "How decisions are kept". Append only. Never edit an earlier entry.

## Step 4: Update the state

Update `context/PROJECT-STATE.md` as the rules say, section "What goes into the project state":
the date at the top, finished items out of the working section, anything new that came up, and
the "Done" section cut to the number of sessions the rules name.

## Step 5: Release the topic

Remove this session's row from `context/session-active.md`. Leave the header.

## Step 5b: The project's own steps

Run the steps listed in the rules under "Your own steps at the end", in order. If the list is
empty, skip this step and do not mention it.

## Step 6: Commit

Follow the rules, section "At the end of a session". By default:

```bash
git add context/
git commit -m "session <YYYY-MM-DD>: <topic>"
```

Check `git status` first and do not commit if nothing changed.

**Only if the project is a git repository.** Many are not, and that is a legitimate way to use
this. If there is no repository, say so once and do not raise it again in later sessions.

**If the repository has a remote, push.** If the push fails or the branch has diverged, say so
plainly rather than working around it.

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

## Rules of this procedure

- No emoji unless asked for.
- Do not commit if there is nothing to commit.
- Do not push a branch that has diverged. Say so instead.
- Never commit secrets, `.env` files or credentials.
