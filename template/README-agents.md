# Context Loop — for Codex and other tools that read AGENTS.md

**Your agent forgets. Your files don't.**

This folder carries your work from one agent session to the next. A session starts by reading
where the last one stopped, and ends by writing down what the next one needs, into plain files
that live here, with you.

This is the version for **Codex** and for any other agent tool that reads a file called
`AGENTS.md` at the start. Nothing to install: this folder is the install.

---

## Set it up once

Open this folder as your project in the tool. That is the setup.

## Then, every session

Say **"start"** to begin and **"close"** to end. Say **"loop?"** to see every procedure and which
ones have run here before.

The first run asks three questions and writes the agent's signature. Every run after that
declares a topic, picks up the last handover on that topic and says what is due. If you skip the
close, the next session has no handover to read. That is the surest way to break this.

## What is here

```
AGENTS.md            one paragraph: read context/rules.md, the procedures are in loop/
context/README.md    the map: every file, what it holds, what to edit to change behaviour
context/rules.md     how the loop behaves here — yours to change
context/             the state: what is being worked on, what happened, what was decided
loop/                the nine procedures the agent follows — read them, they are plain text
loop/scaffold/       the starting files, kept so an older project can be brought up to date
example-session-log.md     what a good session log looks like
```

## Already have an AGENTS.md?

Keep yours and add the text of this one to it. Without it the agent does not know the loop is
there.

github.com/chrisbuilds64/context-loop

---

MIT licence. Do what you like with it.
