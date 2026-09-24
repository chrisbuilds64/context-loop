---
name: todo-done
description: Closes an item on the work list, sets the closing date and names what that unblocks. Validates the file before saving.
disable-model-invocation: false
argument-hint: "[a number, e.g. WRK-03 — or the thing in your own words]"
---

# Todo Done

## How

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
report it; do not work around it.** There is no second way into the file, and that is the
point.
