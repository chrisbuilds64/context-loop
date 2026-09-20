# Context Loop

**Your agent forgets. Your files don't.**

Every new session with an AI agent starts from nothing. You re-explain the project, the decisions,
the thing you were halfway through. Context Loop is the small habit that ends that: a session
starts by reading where the last one stopped, and ends by writing down what the next one needs —
into plain files in your own folder.

Five skills, a handful of files, MIT licensed. No account, no service, no telemetry.

```
/session-start   loads the state, the agent's signature, and the last session's handover
   ... work ...
/session-end     writes the session log, records decisions, updates the state
```

Everything it writes is text you can read, correct, diff and take somewhere else.

---

## What you get

| File | What it holds |
|------|---------------|
| `context/PROJECT-STATE.md` | what is being worked on right now |
| `context/session-logs/` | one short log per session, ending in a handover paragraph |
| `context/session-active.md` | which topics are claimed, so parallel sessions don't collide |
| `context/agents/<name>/` | the agent's signature and what it has learned about working with you |
| `context/decisions.md` | what was decided and why, so it isn't re-argued next month |
| `context/key-inventory.md` | every secret by name — never by value — and how old it is |
| `context/audits/` | what the two audits found, dated |

And five skills:

- **`/session-start`** — loads the state, declares a topic, picks up the thread, lists what is due.
  On the very first run it walks you through drafting the agent's signature.
- **`/session-end`** — writes the log with its handover paragraph, records decisions, updates the
  state, releases the topic, commits.
- **`/security-audit`** — every 14 days: secrets in tracked files, `.gitignore` coverage, history,
  dependencies, what the agent is allowed to do and reach, how old the keys are. It never prints a
  secret.
- **`/doc-audit`** — every 14 days: does the documentation still say what is true?
- **`/new-agent`** — for the day a piece of work needs a different stance than the agent you have.

---

## Install

One way for both environments: **install the plugin.** It carries the five procedures, and the
first `/session-start` creates the `context/` folder in whichever project you are in.

### In the Claude apps (Cowork)

1. **Customize → Plugins → Add marketplace** → `chrisbuilds64/context-loop`
2. Select **Context Loop** and **Install**
3. Open a project on the folder you want to work in, and run `/session-start`

### In Claude Code

```
/plugin marketplace add chrisbuilds64/context-loop
/plugin install context-loop@chrisbuilds64
```

Then `/context-loop:session-start` in any project — Claude Code prefixes plugin procedures with
the plugin name so they cannot collide with your own.

### Without installing anything

Two packages in [Releases](https://github.com/chrisbuilds64/context-loop/releases), for when a
plugin is not wanted or not possible:

- **`ContextLoop-App.zip`** — for the apps. Unzip it, point a project at the folder, paste
  `project-instructions.txt` into the project instructions. The procedures sit in `loop/` as plain
  files; say *"start"* to begin, *"close"* to end, *"loop?"* for the list.
- **`ContextLoop.zip`** — for Claude Code on macOS. Double-click the installer, or clone this repo
  and run `install/install.sh /path/to/your/project`. This is the only package that brings the
  session-start hook, which puts the state in front of the agent before the first word.

Everything in both is plain text you can read before you run anything.

*Verified 2026-09-20: installed from a clean folder in Claude Code, and the whole loop run in
Cowork — signature, topic, session log with its handover. What this repository states as working
is what somebody has actually run.*

---

## Why files

Most tools have some form of memory by now. It is a by-product the agent writes about you: you
cannot read it end to end, correct one wrong line, diff it against last week, or take it with you
when you change tools.

A session log is the opposite. It is short, it is curated, it says what happened and what the next
session should start with — and it is a file in your folder, under your version control, in a
format that outlives whichever agent wrote it.

The loop is four files and the discipline of closing a session. None of that belongs to a vendor.

---

## What is in this repository

```
skills/           the five procedures — the source of truth for them
hooks/            the session-start hook (Claude Code only)
template/         what a project starts with: context/, CLAUDE.md, the instruction block
install/          assemble.sh, install.sh, build-zip.sh, the macOS installer
```

`install/assemble.sh` is the one place that knows how those pieces become an installed project —
under `.claude/` for Claude Code, as plain files in `loop/` for the apps. The installer and both
ZIP builds call it, so there is nothing to keep in sync by hand.

---

## Licence

MIT. Do what you like with it.

Built at [chrisbuilds64.com](https://chrisbuilds64.com).
