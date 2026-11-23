# Rules

How Context Loop behaves in this project. Plain text, and yours to change.

The procedures read this file before they act. Where it says something different from a
procedure, this file wins. An update of Context Loop never overwrites it.

## Settings

A few values that a script reads as well as the agent. Keep the form `name: value`, one per line.

language: en
audit-interval-days: 14
done-sessions-kept: 2

`language` is the language everything is written in that you read: this file, the map, the
signature, session logs, the project state, decisions, and what the agent says to you. File
names, the names of these settings and the names of the commands stay as they are.

## The loop

Start every session with `session-start`. End it with `session-end`. The first reads where the
last one stopped; the last writes it down for the next. A session that is not closed leaves the
next one with nothing to read.

`observe` runs in between, when something surprises you or turns out to have been wrong. The
audits run on the interval set above.

## A session is not a chat

A session here is a stretch of work: it begins with `session-start` and ends with `session-end`.
A chat is the window you type into. One chat can hold several sessions, and one session is
usually one chat. Both work, because the handover is in the files and not in the chat.

The cleaner way is a new chat for each session. Then the agent starts with a clear head and
knows only what the files say, which is exactly what the next person or the next tool will know.
The chat keeps the full conversation; the session log keeps what is worth carrying forward.

## At the start of a session

- Ask one thing only: the topic. Not the time, not the mood, not the place.
- Pick up the thread from the last session log in two or three sentences. Begin with the sentence
  the last session left, do not read it out.
- List what is due, one line each. Name the date. Do not grade the delay.
- Do not propose a focus. What happens today is worked out in conversation.

**Your own steps at the start.** Add them here as a list. The agent runs them after the context
is loaded.

- (none yet)

## At the end of a session

- Write the session log, record the decisions, update the project state, release the topic.
- Commit `context/` if this folder is a git repository. Push if it has a remote. If it is not a
  repository, say so once and do not raise it again.
- Never commit secrets, `.env` files or credentials.

**Your own steps at the end.** Add them here as a list. The agent runs them before the commit.

- (none yet)

## What goes into a session log

One file per session: `context/session-logs/<YYYY-MM-DD>_<slug>.md`. The date leads so the age
of a file is visible in its name.

It holds what happened in this session, and nothing else: what was finished, what was decided,
what broke, what is still open, which commits were made. Factual, grouped by subject, no padding.

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

<only if there were any, otherwise leave the section out>

---

## Open

- [ ] <what is still open>

---

## Commits

- `<hash>` <message>

---

## Continuation Thread

**Still open:** <what remains unresolved, as a problem and not as a task>

**Next natural sentence:** <how the next session would begin if there had been no break>

**Energy:** <productive, frustrating, exploratory? Briefly why, and what that means for the next start>
```

The Continuation Thread is mandatory, also after a short session. It is not a repeat of "Open":
that is the task list, this is the thread of the conversation. "Next natural sentence" is one
concrete sentence, not a subject. Three to five sentences in total.

A session log is history. Once the session is closed, it is not edited.

## What goes into the project state

`context/PROJECT-STATE.md` holds the current value: what is being worked on now, what is next,
what is blocked. It is overwritten at every close.

- It is state, not history. What happened lives in the session logs.
- The "Done" section keeps the last sessions only, as many as `done-sessions-kept` says.
- Never keep a second, numbered copy beside it. There is one current state.

## How decisions are kept

Every decision of a session gets one entry in `context/decisions.md`:

```
## <YYYY-MM-DD> — <what was decided, one line>
**Why:** <the reason>
**Instead of:** <the rejected alternative, if there was one>
```

Append only. A decision that is reversed is a new entry that says so.

## How to work here

- **Read before writing.** Load the state before acting on it.
- **Ask before irreversible things.** Reading, searching and proposing need no permission.
  Writing, deleting, committing and publishing do.
- **Say it once.** Raise a concern clearly, then do what was decided. Do not repeat it.
- **Decided is decided.** Before proposing to change something, check `context/decisions.md`.
  If there is an entry, argue against its reason or leave it.
- **Density over volume.** Short and precise beats long and complete. The conversation carries
  the decision; the file carries the substance.

## Your own rules

Anything below this line is yours: your build commands, your conventions, what this project is.

