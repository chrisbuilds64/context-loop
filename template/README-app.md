# Context Loop

**Your agent forgets. Your files don't.**

This folder carries your work from one agent session to the next. A session starts by reading
where the last one stopped, and ends by writing down what the next one needs — into plain files
that live here, with you.

This is the version for the **Claude apps** (Cowork and the other app surfaces). Nothing to
install, nothing to configure.

---

## Set it up once

1. In the app, create a project and point it at **this folder**.
2. Open the project's **Instructions** and paste in the whole of `project-instructions.txt`.

That is the setup.

## Then, every session

Say **"start"** to begin and **"close"** to end. Say **"loop?"** to see every procedure and which
ones have run here before.

The first reads `context/` and tells you where the last session stopped. The last writes the log,
the decisions and the state. If you skip the close, the next session has nothing to read — that is
the only way to break this.

### Prefer real commands?

Then take the plugin instead of this package: in the app, **Customize → Plugins → Add
marketplace** → `chrisbuilds64/context-loop`, then **Install**. You get `/session-start` and the
other four as commands, in every project, and the first run creates the `context/` folder for you.
This package exists for the case where you would rather not install anything at all.

## What is here

```
context/             the state: what is being worked on, what happened, what was decided
loop/                the procedures the agent follows — read them, they are plain text
project-instructions.txt   the paragraph you paste into the project
example-session-log.md     what a good session log looks like
```

`loop/` holds five procedures: `session-start`, `session-end`, two audits to run every couple of
weeks, and `new-agent` for the day a piece of work needs a different stance.

## Working in a terminal as well?

There is a second version of this pack for **Claude Code**, where the same five procedures are
installed as skills and a hook puts the state in front of the agent before the first word. Same
files, same `context/` folder — you can use both on the same project.

github.com/chrisbuilds64/context-loop

---

MIT licence. Do what you like with it.
