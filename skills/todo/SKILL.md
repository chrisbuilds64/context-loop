---
name: todo
description: Shows the state of the work list — what is due, what is next, what is with someone else, what is blocked. Read-only; it changes nothing.
disable-model-invocation: false
argument-hint: "[optional: a person, a cluster, a status — or nothing for the standard view]"
---

# Todo

A reading view on `context/todo.json`. **Nothing is written.**

## How

Everything goes through `context/scripts/todo.py`. Do not read the JSON file directly and
never edit it by hand — the command is the only way in, and it knows the file's own value
lists.

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
