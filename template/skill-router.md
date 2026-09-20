---
name: context-loop
description: Run the Context Loop session procedures for this project — start a working session, close one, run the security or documentation audit, or set up a second agent. Use at the beginning and end of every working session in a project that has a context/ folder, and whenever the user says start the session, close the session, or asks which loop procedures exist.
---

# Context Loop

The procedures of this project's session loop. Each one is a file in `references/`; read the one
that applies and follow it as written.

| Say | Procedure |
|-----|-----------|
| `start` | `references/session-start.md` — load the state, declare a topic, pick up the thread |
| `close` or `end` | `references/session-end.md` — write the log, record decisions, update the state |
| `security` | `references/security-audit.md` — every 14 days |
| `docs` | `references/doc-audit.md` — every 14 days |
| `new agent` | `references/new-agent.md` — a second agent with a different stance |

**With no argument**, show this table and say which procedures have run in this project before —
that is what `context/session-logs/` and `context/audits/` tell you. Then stop and wait.

## Where the state lives

`context/` in the project folder: `PROJECT-STATE.md` (what is being worked on), `session-logs/`
(what happened, one file per session), `session-active.md` (which topics are claimed),
`agents/` (who you are here), `decisions.md`, `key-inventory.md`, `audits/`.

If there is no `context/` folder, this project has not been set up for the loop. Say so and offer
to create the structure rather than guessing.

## Two things the procedures assume that may not hold here

They were written for a terminal, so read them with these two corrections:

- **There is no session-start hook in this environment.** Where a procedure says the hook reports
  something, work it out yourself from the files — the age of the newest file in `context/audits/`
  tells you whether an audit is due.
- **Commit only if the project folder is a git repository.** If it is not, say so once and carry
  on. Do not mention it again.
