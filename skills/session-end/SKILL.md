---
name: session-end
description: Close the current session. Writes a session log ending in a Continuation Thread, adds its line to the session index, records the decisions, updates PROJECT-STATE.md in place, releases the topic in session-active.md, and commits. Use at the end of every working session.
disable-model-invocation: true
argument-hint: "[optional: slug for the session log filename]"
---

# Session End

You are closing a working session. Work through the steps in order.

**This is the step that makes the whole loop work.** A session that is not closed leaves behind
only what was written while it ran.

**Other sessions may be working in the same folder.** Every file this procedure changes is read
again immediately before the change, and changed where it needs changing: a line added, a line
edited, a row removed. Never write a shared file back from what you read at the start of the
session.

## Step 0: Read the rules

Read `context/rules.md` if you have not read it in this session. It says what a session log
contains, what goes into the project state, how decisions are kept, and which steps of your own
this project runs at the close. **Where it differs from this procedure, the rules win.** Its
`language:` setting is the language everything in this procedure is written in; section names
given here in English may stand in that language in the project. Match them by meaning. The
field names in the head of a session log are never translated.

If the file does not exist, this project was set up before the rules had a file of their own.
Say so in one line, close the session in the default shape (a log with its head, What happened,
Decisions, Open, Commits and a Continuation Thread; a line in `context/session-index.md`;
decisions appended to `context/decisions.md`; the state updated in place, not versioned), and
tell the user that the next `/session-start` creates the file.

## Step 1: Collect

From this conversation: today's date and the time now, which agent worked, which topic was
declared, and every other topic the session moved to and stayed with. If any of it is missing,
look at the beginning of the conversation before asking.

Use the topic names from `context/topics.md`. A topic the session moved to that is not in the
list yet is added there now, as `/session-start` does: a short name, today's date, and one line
to the user saying the name.

## Step 2: Summarise

Go through the whole conversation and pull out what the rules ask a session log to hold.

**If nothing happened in this session** — no work, no decision, nothing said that should last —
there is nothing to hand over, and a log of it would only stand between the next session and the
last real handover. Do not write one, and add no line to the index or the project state. Read
`context/session-active.md` again, remove this session's row (Step 5), say one line, "Nothing to
record; the session is closed.", add what the rules ask to be said after closing, and stop.
This holds even where the rules ask for a log at every close: a log records what happened, and
nothing did. What `/session-start` cleared up at the beginning,
such as an earlier session it closed, is not work of this session.

## Step 3: Write the session log

Create the file in the place, under the name and in the shape given in the rules, section
"What goes into a session log". Use the slug from the argument if there is one, otherwise derive
it from the main subject. Lowercase, hyphens, underscore after the date. If a file of that name
exists already, add `-2` to the slug; never write over a log.

**Fill the six lines of the head, all of them.** `Closed` is the date and time now. `Topics` is
the declared topic first, then the others. `Summary` is one sentence. `Keywords` are the names,
systems, ids and terms somebody would search for in three months. The index is built from these
lines, and a log with an empty head cannot be found.

**If the session made no commits, leave the "Commits" section out.**

**The handover at the end of the log is written last and is never skipped.** It is what the next
session on this topic begins with. **It holds only what is true.** If the session left nothing
open, say so in one sentence; the next natural sentence is then the next step the person named,
or none. Do not invent an open question to fill the form, and do not carry an invented one into
the project state. A line of the handover that would only be filler is left out.

## Step 3a: Add the line to the index

Read the end of `context/session-index.md`, then add one line at the bottom, in the form the
rules give, copied from the head you just wrote:

```
<Closed> | <Topics> | <log file> | <Summary> | keys: <Keywords>
```

Add the line and change nothing above it. If the file does not exist, create it with a heading
and this line; the next `/session-start` completes it from the logs.

## Step 3b: Record the decisions

Read the end of `context/decisions.md` now. Unless the project's setting is
`decisions-written: at-close`, decisions are written there the moment they are made, so most of
this session's may be in the file already.

- **An entry this session wrote while it ran** ends in the line
  `**Log:** (open session, <topic>, started …)`, with this session's topic and start time. Put the file name of this log in place of that note.
  This is the one change to an existing entry that is allowed: completing your own.
- **A decision in the log that has no entry yet** gets one at the bottom, in the form given in
  the rules, section "How decisions are kept": with the topic in square brackets and the file
  name of this log. The reason is written only if one was given: no reason, no `Why` line.
  Never invent one.

Otherwise add only. Never edit an earlier entry, and never write the file back from an earlier
reading.

## Step 3c: What should outlive this session

Three kinds of thing are said in a session and lost in a log. Look for them now.

**A standing rule, or a fact about the project.** "From now on, always …", "we never …", who is
responsible for what, which system does what. The rules ask for these to be written when they are
said. Whatever was said and is not yet in `context/rules.md` under "Principles" or "About this
project", propose now: at most three lines, in one question, each with its date and occasion.
Write the ones the user says yes to, at the bottom of the section. If there are none, skip this
without a word.

One statement goes to one place. A choice about one thing, with a reason and an alternative, is a
decision and is already in `decisions.md` from Step 3b; do not propose it again as a principle. A
principle is a rule for everything that follows, whatever the subject. Whatever already stands
in `decisions.md`, in the rules or on the Focus line of the project state is not proposed a
second time for another place.

**An open item with a date or an owner.** If the project has a work list and the item is not on
it yet, offer once to put it there, and add it after a yes with the `todo-add` procedure. Do it
here, before the state is updated and before the commit, so the state can name the item by its
number and the commit carries the list. An item on the list that this session moved forward
without finishing keeps its place; if its status changed, set it with
`python3 context/scripts/todo.py set <ID> --status <status>`.

**Something learned about working together.** If the user corrected the way you work in this
session, add one dated note at the bottom of your `working-notes.md`, in the form that file
gives: what was said, and what you do differently from now on. This is your own file; do not ask,
and say in one line that you noted it. No correction, no note.

**Observations from `/observe`.** For every file this session wrote into `context/observations/`
whose "Carry forward" names `decisions.md` or the working notes: propose the entry it would
become, and write it after a yes. An observation on "hold" stays where it is.

## Step 4: Update the state

Read `context/PROJECT-STATE.md` again now. Then change it in place, as the rules say, section
"What goes into the project state":

- the date at the top;
- lines of **this session's topics** only: finished items out of the working section, anything
  new that came up, each line beginning with its topic in square brackets. An item that is on the
  work list is named with its number: `[website] WRK-03 server side of the contact form`;
- the "Done" section: add this session, and keep as many entries of each topic as the rules name;
- the Focus line only if the user said the focus has changed.

Leave every line of another topic exactly as it is. If a line of another topic looks wrong or
out of date, say so in the report; do not correct it here.

## Step 5: Release the topic

Read `context/session-active.md` again now. Remove the one row this session added: the row with
its topic and its start time. Leave the header and every other row.

## Step 5b: The project's own steps

Run the steps listed in the rules under "Your own steps at the end", in order. If the list is
empty, skip this step and do not mention it.

## Step 6: Commit

Follow the rules, section "At the end of a session", and any principle there about commits. By
default:

```bash
git add context/
git commit -m "session <YYYY-MM-DD>: <topic>"
```

Check `git status` first and do not commit if nothing changed.

**This commit holds `context/` and nothing else.** If files outside it that **this session**
created or changed are not committed, name them and ask once whether to commit them as well. Do
not commit the user's work unasked, and do not leave it unmentioned. Uncommitted files this
session did not touch belong to someone else's work: leave them, and say in one line that they
are there.

**Only if the project is a git repository.** Many are not, and that is a legitimate way to use
this. If there is no repository, say so once and do not raise it again in later sessions.

**Push only if the rules say `push-at-close: yes`.** If the push fails or the branch has
diverged, say so plainly rather than working around it. With `no`, say in the report that the
commit is local.

## Step 7: Report

Short:

- the name of the session log;
- the state, as a count: "State: 2 lines added, 1 removed, the rest untouched";
- what was committed, and whether it was pushed;
- anything still open that carries a date, with its number on the work list if it has one.

Then whatever the rules ask to be said after closing, in one sentence.

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
