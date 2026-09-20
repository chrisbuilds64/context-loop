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

Two halves: the **skills** are what the agent does, the **files** are what it reads and writes.
Install both once, in the project folder you want the loop in.

### Claude Code

```
git clone https://github.com/chrisbuilds64/context-loop.git
context-loop/install/install.sh /path/to/your/project
```

That puts the files and the skills in your project. Then open the project, start Claude Code and
run `/session-start`.

On macOS you can instead download the ZIP from
[Releases](https://github.com/chrisbuilds64/context-loop/releases) and double-click the installer.
Everything in it is plain text you can read first.

**Or take the skills as a plugin**, available in every project instead of copied into one:

```
/plugin marketplace add chrisbuilds64/context-loop
/plugin install context-loop@chrisbuilds64
```

They are then called `/context-loop:session-start` and so on. The plugin carries the skills, not
the files — the first session still needs a `context/` folder, so run the installer above for that
part, or copy `template/` into your project by hand.

### Claude apps (Cowork)

Add this repository as a plugin marketplace under **Customize → Plugins** and install it, then
create a project that points at the folder you want to work in and paste
`template/project-instructions.txt` into the project instructions. That file is the whole block,
nothing to trim — it is the standing instruction Claude Code would read from `CLAUDE.md`.

*Being tested. Two things are known today: the plugin carries the skills but not the files, so the
folder still needs `template/` copied into it; and what this repository states as working is what
somebody has actually run.*

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
skills/           the five skills — the source of truth for them
hooks/            the session-start hook (Claude Code only)
template/         what a project starts with: context/, CLAUDE.md, .gitignore
install/          assemble.sh, install.sh, build-zip.sh, the macOS installer
```

`install/assemble.sh` is the one place that knows how the pieces become an installed project.
Both the installer and the ZIP build call it, so there is nothing to keep in sync by hand.

---

## Licence

MIT. Do what you like with it.

Built at [chrisbuilds64.com](https://chrisbuilds64.com).
