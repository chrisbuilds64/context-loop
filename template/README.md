# Context Loop

Four files and two skills that carry context from one agent session to the next — in your own
repository, not in a vendor's memory. Plus two audits that keep the repository and the files
honest.

Built and tested for **Claude Code**.

---

## Install

```bash
./install.sh /path/to/your/project
```

Then:

```bash
cd /path/to/your/project
claude
```

and in Claude Code:

```
/session-start
```

That is the install. Nothing to run, nothing to configure, no dependency to add.

A new empty folder works as well as an existing project. `git init` it first if you want the
history — the loop runs without git too.

### Do not copy this folder by hand

**The most important part of this pack is the `.claude` directory, and the leading dot makes it
invisible in Finder and in most file managers.** Select-all and drag will copy the visible files
and silently leave the skills and the hook behind. You get a folder that looks complete, and
`/session-start` does not exist.

Use `install.sh`, which checks afterwards that both skills arrived. If you would rather do it
yourself, the trailing dot is what matters:

```bash
cp -R /path/to/pack/. /path/to/your/project/
```

Then check:

```bash
ls /path/to/your/project/.claude/skills
```

You should see `session-start` and `session-end`.

### If the skills do not show up

Claude Code reads skills at startup. If it was already running when you installed, restart it.

## What you get

```
CLAUDE.md                      how to work here — yours to extend
.claude/skills/session-start/  set up on first run, then load context and pick up the thread
.claude/skills/session-end/    write the log, update state, release the topic
.claude/skills/new-agent/      define a second agent, when one stance is not enough
.claude/skills/security-audit/ every 14 days: secrets, .gitignore, history, dependencies, agent reach
.claude/skills/doc-audit/      every 14 days: do the files above still tell the truth
.claude/hooks/                 puts open topics, uncommitted work and due audits in front of the agent
.claude/settings.json          wires the hook up
context/PROJECT-STATE.md       what is being worked on now
context/session-active.md      which topics are claimed
context/session-logs/          one file per session, each ending in a Continuation Thread
context/agents/                who the agent is, and which agent handles what
context/decisions.md           what was decided and why — append-only, never reopened by accident
context/key-inventory.md       every key by name and age, never by value — the audit reads it
context/audits/                one dated file per audit run
tmp/                           the agent's scratch space, never committed (create when needed)
example-session-log.md         what a good log looks like — an example, not your history
```

## The first session

Run `/session-start`.

The first time, it says what is about to happen and then asks three questions, one at a time,
each in a small dialog — what you want to do with an agent here, what it should be called and
how it should think, and what you do not want from it. It shows a summary, asks whether to
draft, and only then writes the agent's signature and carries straight on.

Every session after that begins with one dialog: which topic this session is about. The topic
is what picks the agent and what the log is filed under.

That signature is the part that matters and the part a blank template never gets filled in. It is
loaded at the start of every session, and the agent does not edit it. When the way you work
together changes, you change it.

Then do some work, and run `/session-end`.

Open the log it wrote in `context/session-logs/`. The last section is the point:

```
## Continuation Thread

**Still open:** ...
**Next natural sentence:** ...
**Energy:** ...
```

**"Next natural sentence" is the mechanism.** Not a summary of what happened — the actual sentence
the next session would open with if there had been no break. The next session reads it and starts
there.

Start a second session and you will see it work.

`example-session-log.md` in this folder shows what a good one looks like. It is deliberately not
inside `context/session-logs/`, because a made-up history is worse than none.

## When one agent is not enough

Most projects never need this. When one does, the reason is a different **direction of thinking**,
not a different task list.

Two agents on the same model with the same stance have the same blind spots — you get a second
copy, not a second opinion. Two that start from different ends catch what the other misses: one
working bottom-up from the requirements, one top-down from the goal, one outside-in from whoever
receives the result.

`/new-agent` writes the signature, creates the directory and registers which topics route to it.
It will also tell you when the agent you are describing is one you already have.

After that, `/session-start` picks the agent from the topic you declare, and says which one it
took.

## Every 14 days

Two more skills, neither part of the loop, both cheap and both about things that go wrong
silently.

`/security-audit` looks at what is in the repository and what the agent has been allowed to do:
secrets in tracked files, files that should never have been committed, `.gitignore` coverage,
the git history, dependency vulnerabilities, the permission rules in `.claude/settings*.json`,
the MCP servers in `.mcp.json`, and the age of every key in `context/key-inventory.md` — a key
older than 90 days is a finding. It never prints a secret. Findings get a number that stays
until the finding is resolved.

`/doc-audit` checks that the files the loop reads every session still tell the truth: the state
against the newest log, logs without a Continuation Thread, a signature that still holds the
template text, paths in `CLAUDE.md` that no longer exist, links that do not resolve, dates that
have passed.

Both write a dated file to `context/audits/`. The session hook reports the age of the newest
one, so the cadence does not depend on anyone remembering.

## Why files

Not ideology. You can read a file. You can diff it, correct an entry that is wrong, delete one,
and hand the whole folder to a different tool next year. Your agent's memory does that work for
you and none of it with you.

## Licence

MIT. Do what you like with it.
