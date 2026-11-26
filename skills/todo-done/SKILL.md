---
name: todo-done
description: Closes an item on the work list, sets the closing date and names what that unblocks. Validates the file before saving.
disable-model-invocation: false
argument-hint: "[a number, e.g. WRK-03 — or the thing in your own words]"
---

# Todo Done

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

## How

**Before the first command, once per session:** the work list needs a helper program called
Python. Check with `python3 --version`; on Windows also try `python --version` and
`py --version`, and use whichever answers in the commands below.

If none answers, do not show the error message. Say it plainly: "The work list needs a small
helper program called Python, and it is not on this computer yet. I can install it for you, or we
leave the work list off. Everything else in Context Loop works without it." Install only after a
yes (macOS: `xcode-select --install`; Windows: `winget install Python.Python.3.12`), then carry
on. On a no, stop here and do not raise it again in this session.

**1. Find the item.** If a number was named, use it. Otherwise search, and **show what you
found for confirmation** before closing anything:

```bash
python3 context/scripts/todo.py list --open | grep -i "<keyword>"
python3 context/scripts/todo.py show <ID>
```

**2. Close it:**

```bash
python3 context/scripts/todo.py done <ID> [--date YYYY-MM-DD]
```

Without `--date` it closes today. An earlier date is right when the work was finished then
and only the record is late.

**3. Report.** One line, plus the numbers this unblocks — the command prints them.

## Rules

- **Done means done, not "essentially".** If a remainder is open, the remainder becomes its
  own item (`/todo-add`) and only then is this one closed.
- **Do not close unasked.** Even when a conversation makes clear that something is finished:
  offer, then close. The other way round is more expensive — an item closed by mistake never
  resurfaces.
- **An item that became moot** — superseded, replaced, decided differently — is closed too,
  but the reason belongs in the session, so it reaches the log.

## When the command refuses

It does not save if the change would damage the file, and it says why. **Read the reason and
report it; do not work around it.** Items change through this command and no other way, and
that is the point. An item that is closed already is refused too: the closing date does not move
by accident.
