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
| `PROJECT-STATE.md` | what is being worked on now |
| `session-logs/` | one file per session, each ending in a handover |
| `session-active.md` | which topics are claimed right now |
| `decisions.md` | what was decided, and why |
| `todo.json` | the work list. Changed only through `scripts/todo.py`, which checks before it saves |
| `observations/` | what the work taught you, before it became a decision |
| `audits/` | what the two audits found, dated in the filename |
| `key-inventory.md` | which keys exist and how old they are, never their values |
| `agents/<name>/<name>-signature.md` | who the agent is. Yours; the agent reads it and does not edit it |
| `agents/<name>/working-notes.md` | what the agent has learned about working here |
| `agents/agent-registry.md` | which agent handles which topic |

## The rules

`rules.md`. One file, plain text.

| You want to change | Edit in `rules.md` |
|--------------------|--------------------|
| how often an audit is due | `audit-interval-days` under Settings |
| what a session log contains | "What goes into a session log" |
| what the project state contains | "What goes into the project state" |
| what the agent asks or lists at the start | "At the start of a session" |
| something that should happen at every start or every close | "Your own steps" in those two sections |
| how the agent works with you in general | "How to work here" and "Your own rules" |

Who the agent is, how it thinks and what it should not do is not a rule. That is the signature,
in `agents/`.

## The procedures

Nine routines: `session-start`, `session-end`, `observe`, `todo`, `todo-add`, `todo-done`,
`security-audit`, `doc-audit`, `new-agent`. Each is one text file. They carry the sequence of
steps; the settings are in `rules.md`.

Where they sit depends on how Context Loop was installed:

| Environment | Where the procedures are |
|-------------|--------------------------|
| Claude Code, installed as a plugin | `~/.claude/plugins/cache/chrisbuilds64/context-loop/`, in `skills/` |
| Claude Code, installed as files | `.claude/skills/` in this project |
| Claude apps, installed as a plugin | on your account, under Customize → Plugins |
| Claude apps, from the ZIP | `loop/` in this project |
| OpenCode | `.opencode/skills/` in this project |

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

Installed as a plugin, there is no such file. `session-start` reads the rules itself.

In Claude Code a small script runs before the first word of a session and reports three facts:
which topics are claimed, how many files are uncommitted, whether an audit is due. Where that
script does not run, `session-start` works the same three facts out from the files.
