# Project Instructions

## Every session

Start with `/session-start`. End with `/session-end`.

That is the whole loop. The first reads where the last one stopped; the last writes it down for
the next. Skipping the close is the only way to break it — a session that is not closed leaves
the next one with nothing to read.

`/observe` runs in between, when something surprises you or turns out to have been wrong. It
keeps one thing in `context/observations/` and declines most of what it is brought. Nothing
breaks if it is never used; what breaks is that the reason behind a decision is gone by the time
somebody asks.

`/new-agent` exists for the day a piece of work needs a different stance than the agent you have.
It is not part of the loop and most projects never need it.

## Every 14 days

`/security-audit` and `/doc-audit`. The session hook says when one is due; the audits themselves
are in `context/audits/`, dated in the filename. The first checks what is in the repository and
what the agent may do and reach. The second checks that the files above still tell the truth.

## Where things are

| What | Where |
|------|-------|
| What is being worked on now | `context/PROJECT-STATE.md` |
| What happened, session by session | `context/session-logs/` |
| Which topics are claimed right now | `context/session-active.md` |
| Who the agent is | `context/agents/<agent>/<agent>-signature.md` |
| What the agent has learned about working here | `context/agents/<agent>/working-notes.md` |
| Which agent handles which topic | `context/agents/agent-registry.md` |
| What was decided, and why | `context/decisions.md` |
| Which keys exist and how old they are | `context/key-inventory.md` |
| What the audits found | `context/audits/` |
| What the work taught us, before it became a decision | `context/observations/` |
| Scratch files, intermediate results | `tmp/` (create it if missing; it is not committed) |

One source of truth per question. If two files seem to track the same thing, one of them is
wrong.

## How to work here

- **Read before writing.** Load the state before acting on it.
- **Ask before irreversible things.** Reading, searching and proposing need no permission.
  Writing, deleting, committing and publishing do.
- **Say it once.** Raise a concern clearly, then do what was decided. Do not repeat it.
- **Decided is decided.** Before proposing to change something, check `context/decisions.md`.
  If there is an entry, argue against its reason or leave it.
- **Density over volume.** Short and precise beats long and complete. The conversation carries
  the decision; the file carries the substance.

<Add your own. Your build commands, your conventions, what this project is. Anything below this
line is yours.>
