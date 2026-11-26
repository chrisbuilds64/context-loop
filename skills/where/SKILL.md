---
name: where
description: Shows which context this session uses and where it lies. Switches to another context, for this session or as the new standard, and sets up a context of its own for one project. Use when the person asks where their context is, or wants a project kept separate.
disable-model-invocation: false
argument-hint: "[nothing to show · a name or a folder to switch · \"own\" for a context of its own here]"
---

# Where

Context Loop keeps what it knows in one folder named `context`. There are two kinds:

- **The standard context.** One fixed place. It applies wherever the person works, unless the
  folder they work in has a context of its own.
- **A context of its own for one project.** It lies in that project's folder and applies only
  there. Nothing passes between it and the standard context, in either direction.

This procedure shows which one applies, switches, and sets up a context of its own.

**Say everything in plain words.** "Your standard context", "this folder's own context", the
names of folders. No "default line", no "mark", no "list file".

## Step 1: Find what applies now

Look in this order and stop at the first that applies. If a session is open in this
conversation, the answer is the place `/session-start` found. If this procedure switched to a
context earlier in this conversation and no session was started since, it is that one.

1. The working folder holds a `context` folder: that one.
2. The file `.context-loop/contexts.md` in the person's home folder (on Windows: in their user
   folder) has one line per context, `<name> | <place> | default`. The line with `default` names
   the standard. If you cannot read the home folder, as in the Claude app, go on.
3. Another folder connected to this session whose `context/rules.md` says
   `default-context: yes` under Settings.
4. None.

Read the whole list file if you can: its other lines are the contexts the person can switch to.

## Step 2: Without an argument — show

Three lines at most:

- which context this session uses, and where it lies: "This session uses your standard context,
  in <place>." or "This session uses this folder's own context, in <folder>."
- the folder being worked in, if it is another one;
- the other contexts in the list, by name and place, if there are any. If one of them is the
  standard and it does not apply here, say so: "Your standard context is <name>, in <place>. It
  does not apply here, because this folder has a context of its own."

If there is none: "There is no context yet. `/session-start` sets one up and asks where it
should live." Then stop. Do not set one up here.

## Step 3: With a name or a folder — switch

The person names a context from the list, or a folder that holds a `context` folder.

**A session belongs to one context.** If a session is open in this conversation
(`/session-start` ran and `/session-end` did not), do not switch. Say: "This session is still
open in <context>. Close it with `/session-end`, then switch." and stop.

**You can only switch to what you can reach.** If the place does not exist, or holds no
`context` folder, say so in one line and stop: there is nothing to switch to. In the Claude app
only a folder added to the project or the chat can be reached: say that the folder has to be
added first, and stop. Ask nothing and write nothing in either case.

Then ask which kind of switch is meant, unless they said it, header `Switch`:

- **For this session** — "The next `/session-start` in this chat uses <name>. Your standard
  stays as it is." Nothing is written. Keep the place for this conversation, and say one line:
  "Switched for this chat. Run `/session-start` to begin there." The start takes this choice
  before anything else it would find, and it stops if the place has become unreachable.
- **As my new standard** — "From now on <name> applies wherever a folder has no context of its
  own."

**As the new standard**, after that answer:

1. In the list file, move the word `default` to the line of the new place. If the place has no
   line yet, add one; the name is what the person calls it, or the name of its folder.
2. In the new place's `context/rules.md`, add `default-context: yes` under Settings, below the
   other settings. In the old place's `context/rules.md`, remove that line, if you can reach it;
   if you cannot, say so in one line.
3. If you cannot write the list file (the Claude app), the line in `context/rules.md` is the
   whole change: say that the new standard applies in every project this folder is added to.
4. Say one line: "<name> is your standard context now."

## Step 4: "own" — a context of its own for this folder

For a project that must stay separate: a client's work, anything that should not meet the rest.

1. **Look at the working folder.** It has to be a folder of the person's that is still there
   tomorrow. A temporary workspace, a chat with no folder connected, and the home folder itself
   are not: say why, and stop.
2. **It has a `context` folder already:** it has its own context. Say so, and stop.
3. **A session is open in this conversation:** ask nothing. Say: "This session is still open.
   Close it with `/session-end`, then run `/where own` again." and stop.
4. **Ask once**, header `Own context`: "This gives the folder <name> a context of its own. From
   then on a session in this folder uses it, and nothing passes between it and your standard
   context: no logs, no decisions, no topics. Set it up?" Options: yes, set it up · no.
5. **On yes:** create an empty folder named `context` in the working folder, and nothing in it.
   If you can write the list file, add a line for it in the form `<name> | <place>`: the name of
   the folder, its full path, and no `default`.
6. Say: "Done. Run `/session-start`, here or in a new chat: it puts the starting files there
   and sets up this context's agent." The start finds the empty folder and does the rest; this procedure cannot,
   because the starting files travel with `/session-start`.

To give a folder back to the standard context, the person removes or renames its `context`
folder. Do not do that for them without being asked, and never delete one: it holds their logs.

## Do not

- Do not copy, move or merge anything between two contexts. That is a later version.
- Do not switch in the middle of an open session.
- Do not make a context the standard, or set one up, without the answer that says so.
