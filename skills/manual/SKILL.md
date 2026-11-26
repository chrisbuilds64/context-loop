---
name: manual
description: The manual of Context Loop. Without an argument it shows the version and every command with one line each; with the name of a command it explains that command briefly. Use when the person asks which commands there are, what one of them does, or which version they have.
disable-model-invocation: false
argument-hint: "[nothing for the list · the name of a command for its page]"
---

# Manual

Like `man` on a Unix system: the list, or one page. It reads nothing of the project and changes
nothing.

**Print what is below, do not paraphrase it into prose.** Translate it into the language the
person writes in; command names stay as they are.

**How the commands are called here.** In Claude Code a plugin's commands carry its name in
front: `/context-loop:session-start`. In the Claude app and in OpenCode they are called by their
own name: `/session-start`. With the file packages the person says a word instead ("start",
"close"). If you know which applies, show the commands that way; if not, show the plain names
and say once that Claude Code puts `context-loop:` in front.

## The version

Read the one line in the file `VERSION` that lies in the same folder as this procedure. That is
the version in use. If the file is not there, say "version not known" and nothing more. Do not
look on the network: `/session-start` says when a newer version is out.

## Without an argument

```
Context Loop <version>

  session-start    begin a session: load the state, name the topic, pick up the thread
  session-end      close it: session log, decisions, state, handover for the next one
  observe          keep something the work just taught you, in one file
  todo             show the work list: due, next, blocked
  todo-add         put an item on the work list
  todo-done        close an item on the work list
  where            show which context applies and where it lies; switch; set up a separate one
  new-agent        add a second agent with a different stance
  security-audit   check for secrets, permissions and old keys
  doc-audit        check that the files still say what is true
  manual           this list; with a command name, its page

  manual <command> explains one of them.
  What changed in each version: https://github.com/chrisbuilds64/context-loop/blob/main/CHANGELOG.md
```

## With the name of a command

Print the page of that command, in this shape, and nothing else. Accept the name with or
without the slash and the plugin name in front. If no command has that name, say so in one line
and print the list.

```
<name> — <what it does, one line>

  Call      <how it is called, with its optional argument>
  Does      <two to four lines>
  Writes    <which files it changes; "nothing" if none>
  Starts    <"only when you call it" or "you, or the agent by itself">
```

The pages:

**session-start** — begin a working session.
Call: `session-start [topic]`.
Does: finds your context (the folder's own, or your standard one), loads the agent's signature
and the state, asks for the topic if it is not clear, picks up where the last session on that
topic stopped, lists what is due. On the very first run it asks where your context should live
and sets up your agent.
Writes: notes the session as open; on the first run, the starting files.
Starts: only when you call it.

**session-end** — close the session.
Call: `session-end [name for the log]`.
Does: writes the session log with a handover for the next session, adds it to the index of
sessions, completes the decisions, updates the project state, notes the session as closed,
commits if the folder is a git repository.
Writes: the log, the index, decisions, project state.
Starts: only when you call it.

**observe** — keep what the work just taught you.
Call: `observe [what you noticed]`.
Does: turns one observation into one short file, or tells you it is not worth keeping. For the
thing you notice mid-session and could not reconstruct in the evening.
Writes: one file in `context/observations/`.
Starts: only when you call it.

**todo** — show the work list.
Call: `todo [a person, a cluster or a status]`.
Does: lists what is due, what is next and what is blocked, one line each. It does not grade and
does not propose.
Writes: nothing.
Starts: you, or the agent by itself.

**todo-add** — put an item on the work list.
Call: `todo-add <what needs doing>`.
Does: adds one item with its number, date and owner, and checks the list before saving. A due
date is set only if you named one.
Writes: the work list.
Starts: you, or the agent by itself.

**todo-done** — close an item.
Call: `todo-done <number, or the thing in your words>`.
Does: closes the item, sets the date and names what that unblocks. It shows what it found
before it closes anything.
Writes: the work list.
Starts: you, or the agent by itself.

**where** — which context applies, and where it lies.
Call: `where` · `where <name or folder>` · `where own`.
Does: shows the context this session uses. With a name or a folder it switches, for this chat
or as your new standard. With `own` it gives the folder you work in a context of its own, kept
separate from everything else.
Writes: nothing when it shows; the list of your contexts when it switches the standard or sets
one up.
Starts: you, or the agent by itself; it asks before it changes anything.

**new-agent** — add a second agent.
Call: `new-agent [what it is for]`.
Does: asks two questions, drafts the new agent's signature and registers which topics it
handles. It tells you when the new one would only be a copy of an agent you have.
Writes: the agent's folder and the list of agents.
Starts: only when you call it.

**security-audit** — the security check.
Call: `security-audit [quick | full]`.
Does: looks for secrets in files, what git ignores, what the agent may do and reach, and how
old the keys are. It never prints a secret. Due every 14 days unless your rules say otherwise.
Writes: a dated report in `context/audits/`.
Starts: only when you call it.

**doc-audit** — the documentation check.
Call: `doc-audit [quick | full]`.
Does: checks that the state, the logs, the index and the documents still say what is true, and
that paths and links still lead somewhere. It fixes what is cheap and lists the rest.
Writes: a dated report in `context/audits/`, and the small fixes it names.
Starts: only when you call it.

**manual** — this manual.
Call: `manual [command]`.
Does: shows the version and the list of commands, or the page of one command.
Writes: nothing.
Starts: you, or the agent by itself.
