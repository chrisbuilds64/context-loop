---
name: todo-add
description: Puts a new item on the work list — mid-session, when it comes up, rather than at the end. Sets the creation date, the assignee and the source itself, and validates the file before saving.
disable-model-invocation: false
argument-hint: "[what needs doing, in your own words]"
---

# Todo Add

Something that comes up mid-session otherwise survives only if somebody writes it into the
session log at the close — so precisely not when the session was long.

## How

**1. Place it, do not ask.** Work out cluster, priority and assignee from the conversation.
The valid values are in the file:

```bash
python3 -c "import json;d=json.load(open('context/todo.json'));print({k:[e['id'] for e in v] for k,v in d['lov'].items()})"
```

If nothing fits, say so — a new cluster is one entry in `lov.clusters`, and adding one is a
decision for the person, not a workaround.

**2. Add it.** The command assigns the number and the creation date:

```bash
python3 context/scripts/todo.py add "Title on one line" \
  --cluster <id> --prio <high|medium|low> --assignee <id> \
  [--due YYYY-MM-DD] [--blocked-by ID,ID] \
  --source-kind session --source-ref "<where this came from>"
```

**3. Report.** One line: the number and the title. Nothing more.

## Rules

- **The title is one line.** Anything longer does not belong in the title. If the context
  matters, it belongs in whatever `--source-ref` points at.
- **A due date is never invented.** Use `--due` only when a date was actually named or is
  fixed from outside. No date is an honest answer.
- **A dependency is not an assignee.** Something waiting on another item gets `--blocked-by`,
  not a person.
- **Check whether the item already exists** (`todo.py list --open`, then search). Duplicates
  are what make lists useless.

## What this does not do

It adds **one** item. When five things come up in a conversation, they are offered one at a
time and decided one at a time — not swept in because they were mentioned.
