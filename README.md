# Context Loop

**Your agent forgets. Your files don't.**

Every new session with an AI agent starts from nothing. You re-explain the project, the decisions,
the thing you were halfway through. Context Loop is the small habit that ends that: a session
starts by reading where the last one stopped, and ends by writing down what the next one needs —
into plain files in your own folder.

Eleven procedures, a handful of files, MIT licensed. No account, no service, no telemetry.
What changed in each version: [CHANGELOG.md](CHANGELOG.md).

```
/session-start   loads the state, the agent's signature, and the last handover on your topic
   ... work ...
/observe         keeps the thing you noticed at 14:20 and can't reconstruct at 19:00
   ... work ...
/session-end     writes the session log, adds it to the index, records decisions, updates the state
```

Everything it writes is text you can read, correct, diff and take somewhere else. There is no
database and no vector search in it: the truth is in the files, and one small index file is the
way into them.

---

## What you get

| File | What it holds |
|------|---------------|
| `context/README.md` | the map: every file, what it holds, and what to edit to change the behaviour |
| `context/rules.md` | how the loop behaves here, in plain text. Yours to change; an update never overwrites it |
| `context/PROJECT-STATE.md` | what is being worked on right now, each line under its topic |
| `context/session-logs/` | one short log per session, ending in a handover paragraph |
| `context/session-index.md` | one line per session: when, which topics, what it did, keywords. The way into the history |
| `context/topics.md` | the topics of the project, and the other words each has been called |
| `context/session-active.md` | which topics are claimed, so a second session on the same topic is noticed |
| `context/agents/<name>/` | the agent's signature and what it has learned about working with you |
| `context/decisions.md` | what was decided and why, so it isn't re-argued next month |
| `context/key-inventory.md` | every secret by name — never by value — and how old it is |
| `context/audits/` | what the two audits found, dated |
| `context/observations/` | what the work taught you, one file at a time |
| `context/todo.json` | the work list: open items with a date, an owner and a status — with a schema beside it, and a command that checks every change |

And eleven procedures. They carry the steps; the settings are in `context/rules.md`:

- **`/session-start`** — loads the state, declares a topic, picks up the thread of that topic,
  lists what is due. On the very first run it walks you through drafting the agent's signature.
- **`/observe`** — mid-session, when you notice something: friction that points at something
  structural, a decision whose reasoning will be invisible in three months, a moment where somebody
  overruled the agent and was right. One file, two minutes. It says no to the rest.
- **`/session-end`** — writes the log with its handover paragraph, adds its line to the index,
  records decisions, updates the state in place, releases the topic, commits.
- **`/security-audit`** — every 14 days unless you set another interval: secrets in tracked files, `.gitignore` coverage, history,
  dependencies, what the agent is allowed to do and reach, how old the keys are. It never prints a
  secret.
- **`/doc-audit`** — on the same interval: does the documentation still say what is true?
- **`/todo`** — what is due, what is next, what is with someone else, what is blocked. Read-only.
- **`/todo-add`** — put an item on the list mid-session, when it comes up rather than at the close.
- **`/todo-done`** — close an item, and see what that unblocks.
- **`/where`** — which context a session uses and where it lies; switches, and gives a project a
  context of its own.
- **`/manual`** — the version you have and every command with one line; `/manual session-end`
  explains one of them.
- **`/new-agent`** — for the day a piece of work needs a different stance than the agent you have.

---

## How it holds together

**Layers by how long they last, not by subject.** What is loaded at every start is small and
changes slowly; what grows is looked up.

| Layer | File | At the start |
|---|---|---|
| How things are done here, and what this project is | `rules.md` | read |
| Who the agent is · what it has learned about working with you | signature · working notes | read |
| What is true right now | `PROJECT-STATE.md` | read |
| Which sessions there were | `session-index.md` | last thirty lines read |
| Where the last session on this topic stopped | one session log | read |
| What was decided, and why | `decisions.md` | looked up by topic |
| What the work taught you | `observations/` | looked up |
| What is open | `todo.json` | what is due is listed |

**Two movements.** A start reads. A close sorts: what happened goes into the log, what was
decided into the decisions, what is true now into the state, a standing rule into the rules. The
index line is a copy of the head of the log, so it can always be rebuilt from the logs.

**Topics are names, not guesses.** You can call a topic whatever comes to mind. The agent brings
it to one name from `topics.md`, says so, and remembers the word. The thread of a topic is then
an exact match, also when several sessions run side by side and close in any order.

In the vocabulary the field uses: session logs are episodic memory, the last section of each is
a handoff, the project state is the active context, `decisions.md` is a decision log, `rules.md`
is an instruction file, and the index is progressive disclosure, the same pattern as an agent's
built-in memory index or a list of skills. What is different here is that all of it sits in
files no tool owns.

## What it does not do

Better read here than found out later.

| | |
|---|---|
| **Checked by a program** | the work list (`todo.py` refuses a change that would break it) and the hook's three facts |
| **Instructed, not enforced** | everything else. The procedures and `rules.md` are text the agent follows. It usually does; nothing forces it to, and a weaker model follows less of it |

- **No search by meaning.** The index finds words. A session about "billing" is not found by
  "invoice" unless one of them is in its keywords. That is the price of having no database, and
  at a few hundred sessions it is a fair one.
- **Several sessions at once** are meant to work on different topics: each one reads a shared
  file again before changing it and touches only its own lines. Two sessions writing in the same
  moment, or a folder synced between computers, can still lose a change. The index repairs itself
  from the logs; the project state does not.
- **A session that is never closed** leaves no log and no handover, only what was written while
  it ran. Decisions are written the moment they are made, so those survive. `/session-start`
  notices the open session and asks; it can rebuild a thin log from the traces, and says that it
  is a reconstruction.
- **You start the procedures, the agent does not.** `/session-start`, `/session-end`, `/observe`,
  the two audits and `/new-agent` run only when you call them. That is on purpose: when a session
  begins and ends is your call. The three work-list procedures, `/where` and `/manual` the agent
  may use by itself; `/where` asks before it changes anything.
- **What is written into these files is read as context.** A line in a log or a note is
  information about the past, not an instruction. The signature is yours alone; the agent adds
  to `rules.md` only a line you said yes to.
- **Not in this stage:** syncing between devices, a team working on one loop, merging two
  contexts, a context reached from a phone or a browser, automatic shortening of old logs.

---

## Where your context lives

Context Loop keeps everything it knows in one folder named `context`. That folder does not have
to be in the folder you are working in. There are two kinds, and one rule.

- **Your standard context.** One fixed place, chosen once: a folder named `ContextLoop` in your
  home folder unless you name another. It applies wherever you work. Open a session in any
  folder, run `/session-start`, and it loads from there and writes back there.
- **A context of its own for one project.** It lies in that project's folder and applies only
  there. Nothing passes between it and your standard context, in either direction: no logs, no
  decisions, no topics. The choice for a client's work.

**The rule:** if the folder you work in has a context of its own, that one applies. Otherwise
your standard context does.

The first `/session-start` asks once where your context should live. After that a start in a new
folder creates nothing there; it says in one line where it works and where your context is. A
context of its own is set up only when you ask for one, with `/where own`.

In your standard context the folder decides the topic: the start remembers which folder belongs
to which topic and does not ask again.

**How a session finds your standard context depends on the tool.**

| Where you work | How it is found |
|---|---|
| An editor or a terminal (Claude Code, OpenCode, Codex) | Through a small list in your home folder, `.context-loop/contexts.md`: one line per context, one of them marked as the standard. The list holds names and places, nothing of the content. |
| The Claude app, in a project | The app cannot read your home folder. Add your `ContextLoop` folder to the project, beside the folder you work in; the start recognises it by a line in its settings. |
| The Claude app, in a single chat | Add the `ContextLoop` folder to the chat, each time. |

**In Claude Code** the first start offers to allow the folder of your context in your settings
(`permissions.additionalDirectories`), so that you are not asked before each file there. It
shows the entry first and writes it only after a yes. Say no, and it shows you the entry to add
yourself.

**An existing project stays as it is.** A folder that has a `context` folder from an earlier
version has a context of its own by the rule above, and nothing about it changes.

`/where` shows which context a session uses, switches to another one for a chat or for good,
and sets up a separate one. Two contexts cannot be merged yet.

**What lies under a folder is what the agent can read.** A context for everything is one folder
with everything in it: keep out of it what an agent should not see, and give work that must
stay apart a context of its own. The same holds for the folder you work in: one that holds the
whole of a piece of work gives the agent something to check a statement against; one that holds
a corner of it gives a context that is right about that corner and knows nothing of the rest.

## Install

In the Claude environments the way in is the plugin; in OpenCode and Codex it is files. Either
way the first session start asks where your context should live and creates it there.

### In the Claude apps (Cowork)

1. **Plugins → Add → Add marketplace**, enter `chrisbuilds64/context-loop`, **Sync**
2. On the Plugins page, search for **Context Loop**, open it and select **Add**. Confirm the
   notice about components that run code
3. Create a project on your folder: **Projects → + → Use an existing folder**. Every new chat
   you start in that project then works in that folder
4. Start a chat in the project and run `/session-start`. It asks where your context should
   live: in this folder, or in one place for everything. For the one place, make a folder named
   `ContextLoop` on your computer and add it to the project as a second folder

**A folder has to be added.** In the app Context Loop can keep its files only in a folder that
is added to the project or the chat. If no folder is added, every chat gets an empty workspace of its own and nothing carries over to
the next one. Connecting your computer is not the same as adding the folder.

- **A project is the way that stays set up.** It keeps the folder, so you add it once.
- **A single chat outside a project** needs the folder each time: before you send your first
  message, click the **+** button in the chat's message box, choose **Add folder**, and pick
  your project folder.

`/session-start` says which folder it is in, and asks before it sets anything up in an empty or
temporary one. If the folder it names is not yours, stop there and add yours first.

The marketplace and the plugin carry the same name in the app. The first is the shelf, the second
is what you take from it.

The app asks for access to the folder before the first run. A session in the app runs on
Anthropic's servers, so the files the agent reads leave your computer for that purpose, as with
any work you give the app. Context Loop itself sends nothing of yours anywhere. The one thing it
reads from the network is its own newest version number (see "Updating").

### In Claude Code

```
/plugin marketplace add chrisbuilds64/context-loop
/plugin install context-loop@chrisbuilds64
```

Then `/context-loop:session-start` in any project — Claude Code prefixes plugin procedures with
the plugin name so they cannot collide with your own.

### Updating

A new version does not arrive by itself in every tool. `/session-start` tells you in one line
when a newer one is out, and how to get it:

- **Claude apps:** Customize → Plugins → the marketplace **context-loop** → **Check for
  updates**. Then start a new chat; an open chat keeps the version it started with. "Sync
  automatically" on the marketplace has not fetched new versions reliably for us.
- **Claude Code:** `/plugin marketplace update chrisbuilds64`, then start a new session. To have
  it done for you: `/plugin` → Marketplaces → chrisbuilds64 → turn auto-update on. It is off by
  default for every marketplace that is not Anthropic's own.
- **OpenCode, Codex and the file packages:** download the new package and replace the
  procedures. Your `context/` folder stays as it is.

An update never touches your own files. What changed is in [CHANGELOG.md](CHANGELOG.md).

To find out about a new version, `/session-start` reads one public file, the version number in
this repository, once per start. It sends nothing of your project. `update-check: no` in the
settings of `context/rules.md` turns it off.

### In OpenCode

OpenCode reads the procedures straight from the project, so there is no plugin to install — the
loop travels as files.

**In one project:**

```bash
install/install.sh /path/to/your/project --opencode
cd /path/to/your/project && opencode
```

**Once, for every project:** clone this repository and point the global config at it —
`~/.config/opencode/opencode.json`:

```json
{
  "skills": { "paths": ["~/context-loop/skills"] }
}
```

A leading `~` is resolved. The procedures are then available everywhere; the `context/` folder is
still created per project by the first `/session-start`.

Two things are specific to OpenCode: the state block at the top of `/session-start` is produced by
an embedded shell call, which runs in the terminal interface but not in `opencode run`; and the
procedures need a model with a real context window — `session-start` is around 3,000 tokens and
OpenCode's own system prompt takes roughly 10,000, so a 16k local model has nothing left.

### In Codex, and in other tools that read AGENTS.md

Take **`ContextLoop-Codex.zip`** from [Releases](https://github.com/chrisbuilds64/context-loop/releases),
unzip it and open the folder as your project. Say *"start"* to begin and *"close"* to end. The
procedures sit in `loop/` as plain files and `AGENTS.md` tells the agent they are there. Nothing
in this layout is specific to one vendor.

### Without installing anything

Four packages in [Releases](https://github.com/chrisbuilds64/context-loop/releases), for when a
plugin is not wanted or not possible. They are built from this repository by
`install/build-zip.sh`; if the release is older than what you read here, build them yourself:

- **`ContextLoop-App.zip`** — for the apps. Unzip it, point a project at the folder, paste
  `project-instructions.txt` into the project instructions. The procedures sit in `loop/` as plain
  files; say *"start"* to begin, *"close"* to end, *"loop?"* for the list.
- **`ContextLoop-Codex.zip`** — for Codex and other tools that read `AGENTS.md`. Unzip it, open the
  folder, say *"start"*.
- **`ContextLoop-OpenCode.zip`** — for OpenCode. Unzip it, `cd` in, run `opencode`, type
  `/session-start`.
- **`ContextLoop.zip`** — for Claude Code on macOS. Double-click the installer, or clone this repo
  and run `install/install.sh /path/to/your/project`. This is the only package that brings the
  session-start hook, which puts the state in front of the agent before the first word.

Everything in all four is plain text you can read before you run anything.

*What has been run, and when. A row is here because somebody ran it, not because it should work.*

| Environment | Run | What |
|---|---|---|
| Claude Code, as files | 2026-11-23 | from an empty folder: first start, close, second start picks up the handover |
| OpenCode | 2026-11-23 | from an empty folder: first start |
| Codex | 2026-11-23 | first start, close, second start |
| Claude Code and Claude apps, as a plugin | 2026-09-20 | the loop as it was then: signature, topic, session log with its handover. Not yet repeated with the rules file |
| Windows | not run | |

*The three runs of 2026-11-23 were made without the question dialogs: the answers to the first-run
questions were given in advance.*

---

## What runs where

The loop is the same everywhere. Codex works like the app column, with `AGENTS.md` in place of the
project instructions. Five things differ, and it is better to know them before you
rely on one:

| | Claude Code | Claude apps (Cowork) | OpenCode |
|---|---|---|---|
| **How you call it** | `/context-loop:session-start` — plugin procedures are prefixed with the plugin name | `/session-start` — listed under its own name | `/session-start` — the eleven procedures ship with a command each |
| **State before the first word** | The session-start hook reports claimed topics, uncommitted work and a due audit | No hook output. `/session-start` works it out from the files instead | The `/session-start` command embeds the same report — in the terminal interface, not in `opencode run` |
| **git** | Assumed. `/session-end` commits; it pushes only if `push-at-close` in the rules says yes | Often no repository at all. The close says so once and carries on | Assumed, same as Claude Code |
| **Where it lives** | Files in your project, or the plugin in your Claude Code config | The plugin on your account; the state files in the project's folder | Files in your project under `.opencode/`, or one global `skills.paths` entry |
| **Model** | Claude | Claude | whatever you point it at — needs a 32k context and reliable tool calling |

Two things are the same and matter more: the `context/` folder has the identical shape in all
three, and the procedures are the same text. **One project can be worked on from any of them** —
terminal in the morning, app in the evening, one loop.

### About the shell script

The plugin ships one executable: the session-start hook. The apps flag this as *"can run code
without asking"*, and that warning is correct — so here is what it does. It reads three things
and prints them as text for the agent: the rows in `context/session-active.md`, the number of
uncommitted files from `git status`, and the date in the name of the newest file in
`context/audits/`. It sends nothing anywhere, writes nothing, and never opens a file that could
hold a secret. It also reads one number, the audit interval, from `context/rules.md`, and in a
folder without a `context/` folder it does nothing at all: it never reads your standard context.
What is in there is loaded only when you run `/session-start`. About fifty lines of shell and as
many of comment, in `hooks/session-context.sh`, and worth reading before you install anything
that can run code.

---

## Why files

Most tools have some form of memory by now. It is a by-product the agent writes about you: you
cannot read it end to end, correct one wrong line, diff it against last week, or take it with you
when you change tools.

A session log is the opposite. It is short, it is curated, it says what happened and what the next
session should start with — and it is a file in your folder, under your version control, in a
format that outlives whichever agent wrote it.

The loop is a handful of files and the discipline of closing a session. None of that belongs to
a vendor.

---

## What is in this repository

```
skills/           the eleven procedures — the source of truth for them
  session-start/scaffold/   the state files a new project starts with
hooks/            the session-start hook (Claude Code; OpenCode calls the same script with --plain)
adapters/         the per-environment wiring — currently opencode/ (eleven commands, one config)
template/         the pointer files (CLAUDE.md, the instruction block that also becomes AGENTS.md),
                  .gitignore, the example log, the README of each package
install/          assemble.sh, install.sh, build-zip.sh, the macOS installer
```

How the loop behaves is not in the procedures. It is in `context/rules.md`, a plain-text file in
the user's folder that an update never overwrites; `context/README.md` is the map of every file.
Both start in the scaffold.

The scaffold sits inside the skill on purpose: `session-start` creates the state on a first run,
and a skill can reliably read its own directory and nothing above it. Everything the packages
ship is assembled from there, so the starting files exist once.

`install/assemble.sh` is the one place that knows how those pieces become an installed project —
under `.claude/` for Claude Code, as plain files in `loop/` for the apps and for Codex, under
`.opencode/` for OpenCode. The installer and the ZIP builds call it, so there is nothing to keep in sync by hand.

---

## Licence

MIT. Do what you like with it.

Built at [chrisbuilds64.com](https://chrisbuilds64.com).
