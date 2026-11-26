# The map

Everything Context Loop does in this project is written down in a file you can open. This page
says which file holds what, and what you edit to change the behaviour.

There are three parts.

| Part | What it is | Where | Who changes it |
|------|------------|-------|----------------|
| **State** | What is being worked on, what happened, what was decided | this folder | the loop writes it, you may edit it |
| **Rules** | How the loop behaves here | `rules.md` in this folder | you |
| **Procedures** | The step-by-step routines the agent follows | in the Context Loop package | updates of Context Loop |

## The state

| File | What it holds |
|------|---------------|
| `PROJECT-STATE.md` | what is being worked on now, each line under its topic |
| `session-logs/` | one file per session, each ending in a handover |
| `session-index.md` | one line per session: when, which topics, what it did, keywords. The way into the logs |
| `topics.md` | the topics of this project, and the other words each has been called |
| `session-active.md` | which topics are claimed right now |
| `decisions.md` | what was decided, and why, each entry under its topic |
| `todo.json` | the work list. Items change only through `scripts/todo.py`, which checks before it saves |
| `observations/` | what the work taught you, before it became a decision |
| `audits/` | what the two audits found, dated in the filename |
| `key-inventory.md` | which keys exist and how old they are, never their values |
| `agents/<name>/<name>-signature.md` | who the agent is. Drafted from your answers on the first run, yours from then on; the agent reads it and does not edit it |
| `agents/<name>/working-notes.md` | what the agent has learned about working here |
| `agents/agent-registry.md` | which agent handles which topic |
| `folders.md` | only in a standard context: which folder you work in belongs to which topic. Created when it is first needed |

## Where this folder applies

A context is either **your standard context** or **the context of one project**.

- Your standard context lies in one fixed place and applies in every folder you work in that has
  no context of its own. It carries the line `default-context: yes` in the settings of
  `rules.md`, and its place is noted in `.context-loop/contexts.md` in your home folder.
- The context of one project lies in that project's folder and applies only there. Nothing
  passes between it and your standard context.

`/where` shows which one a session uses, switches, and sets up a context of its own for a folder.

## The rules

`rules.md`. One file, plain text.

| You want to change | Edit in `rules.md` |
|--------------------|--------------------|
| the language everything is written in | `language` under Settings |
| how often an audit is due | `audit-interval-days` under Settings |
| whether the close pushes after its commit | `push-at-close` under Settings |
| what a session log contains | "What goes into a session log" |
| what the project state contains | "What goes into the project state" |
| a standing rule for this project | "Principles". The agent proposes a line, you say yes |
| a fact the agent should always know | "About this project". Same way in |
| what the agent asks or lists at the start | "At the start of a session" |
| something that should happen at every start or every close | "Your own steps" in those two sections |
| how the agent works with you in general | "How to work here" and "Your own rules" |

Who the agent is, how it thinks and what it should not do is not a rule. That is the signature,
in `agents/`.

## What is loaded, and what is looked up

At the start of every session the agent reads the rules, its signature and working notes, the
project state, the list of topics and the last thirty lines of the index. Then it reads one
session log: the last one on the topic you named.

Everything else is looked up when it is needed: older logs through the index, decisions through
their topic, observations by file name. That keeps the start short however long the history gets,
and it is why the head of a log and the topic of a decision have to be filled in.

## Who writes what

| File | Written by |
|------|------------|
| the signature | you. The first run drafts it from your answers; after that the agent reads it and never edits it |
| `rules.md` | you. The agent adds a line under "Principles" or "About this project" only after your yes |
| working notes | the agent, dated, about how you work together |
| logs, index, decisions, state | the agent, at the close. You may correct any of them |
| `todo.json` | the `todo` commands, which check every change |

Text in these files is context for the agent, not a command to it. If a line in a log or a note
tells the agent to do something, it treats that as information about the past.

## Session and chat

A session is a stretch of work, from `session-start` to `session-end`. A chat is the window you
type into. They can be the same thing and do not have to be: several sessions fit into one chat,
and a new chat for each session is the cleaner way, because the agent then knows only what the
files say. The chat keeps everything that was said. The session log keeps what the next session
needs.

## The procedures

Eleven routines: `session-start`, `session-end`, `observe`, `todo`, `todo-add`, `todo-done`,
`where`, `manual`, `security-audit`, `doc-audit`, `new-agent`. `manual` lists them with a line
each. Each is one text file. They carry the sequence of
steps; the settings are in `rules.md`.

Where they sit depends on how Context Loop was installed:

| Environment | Where the procedures are |
|-------------|--------------------------|
| Claude Code, installed as a plugin | `~/.claude/plugins/cache/chrisbuilds64/context-loop/`, in `skills/` |
| Claude Code, installed as files | `.claude/skills/` in this project |
| Claude apps, installed as a plugin | on your account, under Customize → Plugins |
| Claude apps, from the ZIP | `loop/` in this project |
| OpenCode | `.opencode/skills/` in this project |
| Codex, and other tools that read `AGENTS.md` | `loop/` in this project |

They are replaced when Context Loop is updated. Change the behaviour in `rules.md`, not in a
procedure, or the next update takes your change with it.

## What each environment adds

Each environment has its own file that it reads at the start. With Context Loop it holds one
sentence: read `context/rules.md` and follow it.

| Environment | That file |
|-------------|-----------|
| Claude Code | `CLAUDE.md` |
| Claude apps | the project's Instructions |
| OpenCode | `AGENTS.md` |
| Codex | `AGENTS.md` |

Installed as a plugin, there is no such file. `session-start` reads the rules itself.

In Claude Code a small script runs before the first word of a session and reports three facts:
which topics are claimed, how many files are uncommitted, whether an audit is due. Where that
script does not run, `session-start` works the same three facts out from the files.

## What this does not do

- **Only the work list is checked by a program.** Everything else is an instruction the agent
  follows. It usually does; nothing forces it to.
- **The index finds words, not meanings.** A search for "invoice" does not find a session that
  only said "billing". Keywords in the head of a log are what make it findable.
- **Several sessions at once** work when they are on different topics. Two sessions writing the
  same file in the same moment, or a folder synced between computers, can still leave one change
  behind. The index repairs itself from the logs; the project state does not.
- **A session that is never closed** leaves only what was written while it ran: principles,
  project facts, work-list items, observations. There is no log and no handover for it.
