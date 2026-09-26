# Context Loop — for OpenCode

Nine procedures that carry context from one agent session to the next, in your own folder.
A session starts by reading where the last one stopped and ends by writing down what the next
one needs.

---

## Install

You already have it: this folder is the install. Point OpenCode at it.

```bash
cd /path/to/this/folder
git init          # optional — the loop runs without it, the close commits when it is there
opencode
```

Then, in OpenCode:

```
/session-start
```

The first run asks three questions and writes the agent's signature. Every run after that
declares a topic, picks up the last session's handover and says what is due.

**If the commands do not show up:** OpenCode reads skills and config at startup. Restart it.

## What you get

```
AGENTS.md                        how to work here — yours to extend
.opencode/skills/                the nine procedures, each one also a slash command
.opencode/commands/session-start.md   the one command that hands the state over first
.opencode/session-context.sh     reports claimed topics, uncommitted work, due audits
opencode.json                    points at AGENTS.md
context/PROJECT-STATE.md         what is being worked on now
context/session-active.md        which topics are claimed
context/session-logs/            one file per session, each ending in a Continuation Thread
context/agents/                  who the agent is, and which agent handles what
context/decisions.md             what was decided and why — append-only
context/key-inventory.md         every key by name and age, never by value
context/audits/                  one dated file per audit run
context/observations/            what the work taught you, one dated file at a time
tmp/                             scratch space, never committed (create when needed)
example-session-log.md           what a good log looks like — an example, not your history
```

## The loop

```
/session-start   loads the state, the signature, and the last session's handover
   ... work ...
/observe         keeps the thing you noticed at 14:20 and cannot reconstruct at 19:00
   ... work ...
/session-end     writes the log, records decisions, updates the state, releases the topic
```

Every 14 days: `/security-audit` and `/doc-audit`. The state block at the top of
`/session-start` says when one is due.

`/todo`, `/todo-add`, `/todo-done` work the list in `context/todo.json`; `/new-agent` is for the
day a piece of work needs a different stance than the agent you have.

## Two things that are specific to OpenCode

**The state block only appears in the TUI.** `/session-start` embeds the output of
`.opencode/session-context.sh` in its prompt, and OpenCode runs embedded shell at invocation
time — in the terminal interface, not in `opencode run`. Headless, the procedure reads the same
files itself; it just does not get them handed over first.

**Model:** the procedures are long — `session-start` is around 3,000 tokens, and OpenCode's own
system prompt takes roughly 10,000. A local model with a 16k window has nothing left to work
with. Use a model with at least a 32k context and reliable tool calling.

## Licence

MIT. Do what you like with it.
