---
name: todo
description: Shows the state of the work list — what is due, what is next, what is with someone else, what is blocked. Read-only; it changes nothing.
disable-model-invocation: false
argument-hint: "[optional: a person, a cluster, a status — or nothing for the standard view]"
---

# Todo

**Where the context is.** Every path here that begins with `context/` lies in the context of
this session, and that folder is not always in the working folder. If `/session-start` ran in
this conversation, it is the place found there, until `/session-end`. If `/where` switched to a
context in this conversation, it is that one. Otherwise look, in this order: a `context` folder
in the working folder; the place on the line marked `default` in the file
`.context-loop/contexts.md` in the person's home folder; another folder connected to this
session whose `context/rules.md` says `default-context: yes`. Read `context/…` as a path inside
that place, in commands as well. If there is none, say in one line that there is no context yet
and that `/session-start` sets one up, and stop.

**The rules of this project are in `context/rules.md`.** If you have not read that file in this
session, read it now. Where it says something different from this procedure, the rules win.

A reading view on `context/todo.json`. **Nothing is written.**

## How

**Before the first command, once per session:** the work list needs a helper program called
Python. Check with `python3 --version`; on Windows also try `python --version` and
`py --version`, and use whichever answers in the commands below.

If none answers, do not show the error message. Say it plainly: "The work list needs a small
helper program called Python, and it is not on this computer yet. I can install it for you, or we
leave the work list off. Everything else in Context Loop works without it." Install only after a
yes (macOS: `xcode-select --install`; Windows: `winget install Python.Python.3.12`), then carry
on. On a no, stop here and do not raise it again in this session.

Everything goes through `context/scripts/todo.py`. Do not read the JSON file directly and do
not edit items by hand — the command is the way in, and it knows the file's own value lists
(`todo.py values`).

**Without an argument** — the standard view, three calls:

```bash
python3 context/scripts/todo.py list --due 21         # due within three weeks
python3 context/scripts/todo.py list --status next    # what is next
python3 context/scripts/todo.py list --blocked --open # what waits on something else
```

**With an argument** — narrow to the person, cluster or status named:

```bash
python3 context/scripts/todo.py list --assignee me --open
python3 context/scripts/todo.py list --cluster work
```

The valid values live in the file itself, under `lov`. The command names them when a value
does not fit — read the error rather than guessing.

## Output

**Compact.** One item per line: number, title, due date when there is one, who holds it. No
prose, no assessment.

A `!` at the start of a line means the due date has arrived or passed.

**The order is due date first, then priority.** What has no date sits at the end. That is not
a judgement about importance — it is the only ordering that needs no opinion.

## What this does not do

- **It does not grade.** No "overdue since", no "again". The date is there; that is enough.
- **It does not propose what to work on.** Show the list, then wait.
- **It changes nothing.** Closing an item is `/todo-done`.
