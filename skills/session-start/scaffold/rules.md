# Rules

How Context Loop behaves in this project. Plain text, and yours to change.

The procedures read this file before they act. Where it says something different from a
procedure, this file wins. An update of Context Loop never overwrites it.

The agent writes into this file in two places only, "Principles" and "About this project", one
line at a time, and only after you said yes to that line.

## Settings

A few values that a script reads as well as the agent. Keep the form `name: value`, one per line.

rules-version: 3
language: en
audit-interval-days: 14
done-sessions-kept: 2
push-at-close: no
decisions-written: when-made

`language` is the language everything is written in that you read: this file, the map, the
signature, session logs, the project state, decisions, and what the agent says to you. File
names, the names of these settings, the field names in the head of a session log and the names of
the commands stay as they are.

`push-at-close: yes` lets `session-end` push after its commit. With `no` it commits and leaves the
push to you.

`decisions-written: when-made` has the agent write a decision into `decisions.md` the moment it
is made. With `at-close` it records them when the session is closed; a session that is never
closed then loses them.

## The loop

Start every session with `session-start`. End it with `session-end`. The first reads where the
last one on this topic stopped; the last writes it down for the next. A session that is not
closed leaves behind only what was written while it ran.

`observe` runs in between, when something surprises you or turns out to have been wrong. The
audits run on the interval set above.

## A session is not a chat

A session here is a stretch of work: it begins with `session-start` and ends with `session-end`.
A chat is the window you type into. One chat can hold several sessions, and one session is
usually one chat. Both work, because the handover is in the files and not in the chat.

The cleaner way is a new chat for each session. Then the agent starts with a clear head and
knows only what the files say, which is exactly what the next person or the next tool will know.
The chat keeps the full conversation; the session log keeps what is worth carrying forward.

## At the start of a session

- Ask one thing only: the topic. Not the time, not the mood, not the place. (The very first
  start asks a few more questions, once, to draft the agent's signature.)
- Pick up the thread from the last session on this topic in two or three sentences. Begin with
  the sentence that session left, do not read it out. If there was none on this topic, say so.
- List what is due, one line each. Name the date. Do not grade the delay.
- If earlier sessions were never closed, say so and ask whether to close them. Always ask;
  never close one silently.
- Do not propose a focus. What happens today is worked out in conversation.

**Your own steps at the start.** Add them here as a list. The agent runs them after the context
is loaded.

- (none yet)

## At the end of a session

- Write the session log, add its line to the index, record the decisions, update the project
  state, release the topic.
- Commit `context/` if this folder is a git repository. Push only if `push-at-close` says yes. If
  it is not a repository, say so once and do not raise it again.
- Never commit secrets, `.env` files or credentials.
- After closing, say once that the next session is best started in a new chat.

**Your own steps at the end.** Add them here as a list. The agent runs them before the commit.

- (none yet)

## Topics

Every session has a topic. `context/topics.md` is the list of them: one short name each, and the
other words the same topic has been called.

- A topic's name is lowercase, with hyphens, and it does not change once it is in use.
- Session logs, the index, decisions and the project state always carry that name, never a
  variant. Finding the thread of a topic is then an exact match.
- When you name a topic in other words, the agent matches it once, at that moment, and says so in
  one line: "'homepage' runs under website". The word is added under "Also called". If the agent
  is not sure, it asks once, offering the nearest topics and "a new topic".
- Two names that turn out to be one topic are joined by moving one name into "Also called" of the
  other. No log is edited. The thread of the topic is then every session under either name.

## What goes into a session log

One file per session: `context/session-logs/<YYYY-MM-DD>_<slug>.md`. The date leads so the age
of a file is visible in its name. If a file of that name exists, the new one gets `-2` at the end
of its slug.

It holds what happened in this session, and nothing else: what was finished, what was decided,
what broke, what is still open, which commits were made. Factual, grouped by subject, no padding.
"Commits" lists the commits made while working; the commit of the close itself is not listed,
because it is the one that carries this log. If there were none, leave the section out.

```markdown
# Session <YYYY-MM-DD> — <title>

**Date:** <YYYY-MM-DD>
**Closed:** <YYYY-MM-DD HH:MM>
**Agent:** <name>
**Topics:** <the declared topic>, <every other topic the session moved to>
**Summary:** <one sentence: what this session did>
**Keywords:** <names, systems, ids and terms somebody would search for>

---

## What happened

<grouped summary>

---

## Decisions

<only if there were any, otherwise leave the section out>

---

## Open

- <what is still open>

---

## Commits

- `<hash>` <message>

---

## Continuation Thread

**Still open:** <what remains unresolved, as a problem and not as a task>

**Next natural sentence:** <how the next session would begin if there had been no break>

**Energy:** <productive, frustrating, exploratory? Briefly why, and what that means for the next start>
```

The six lines at the top are the head. They are what the index is built from, so they are filled
in every time, with the topic names from `context/topics.md`. `Keywords` are for searching: write
the words somebody will type in three months, not a second summary.

The Continuation Thread is mandatory, also after a short session. It is not a repeat of "Open":
that is the task list, this is the thread of the conversation. It holds only what is true: if
nothing was left open, it says so, and no question is invented to fill it. "Next natural sentence" is one
concrete sentence, not a subject. Three to five sentences in total. A session that leaves two
topics open writes one next sentence for each, naming the topic, because the next session on
either of them starts from this log.

A session log is history. Once the session is closed, it is not edited.

## The index of sessions

`context/session-index.md` holds one line per session, oldest at the top:

```
<YYYY-MM-DD HH:MM> | <topics> | <log file> | <summary> | keys: <keywords>
```

- The line is a copy of the head of the log. **The log is the truth, the index is the way in.**
  A line that is missing or wrong is rebuilt from the log; the log is never changed to fit.
- `session-end` adds the line. `session-start` checks that every log has one and adds what is
  missing.
- The thread of a topic is the line with the latest time among those that name it. Lines can
  stand out of order after two computers were merged; the time decides, not the position.
- The start reads the last thirty lines. Further back, search the file for a topic or a keyword
  and open only the logs that the lines point to. Never read through all the logs.

## What goes into the project state

`context/PROJECT-STATE.md` holds the current value: what is being worked on now, what is next,
what is blocked. It is updated in place at every close, never rebuilt from memory.

- It is state, not history. What happened lives in the session logs.
- Every line begins with its topic in square brackets: `[website] contact form sends twice`.
  A section with nothing in it says `(none yet)`; the first real line takes its place.
- A session reads the file again immediately before writing, and changes only lines of its own
  topics. Lines of other topics stay as they are; another session may have written them an hour
  ago.
- The Focus line changes only when you say the focus has changed.
- The "Done" section keeps the last sessions of each topic, as many as `done-sessions-kept` says.
  A session that worked on two topics writes one line under each.
- An open item with a date or an owner belongs on the work list (`context/todo.json`), if the
  project has one. The state then names the item with its number, not a second copy of it.
- Never keep a second, numbered copy beside it. There is one current state.

## How decisions are kept

Every decision of a session gets one entry in `context/decisions.md`:

```
## <YYYY-MM-DD> — [<topic>] <what was decided, one line>
**Why:** <the reason, if one was given>
**Instead of:** <the rejected alternative, if there was one>
**Log:** <file name of the session log>
```

The entry is written the moment the decision is made, not at the close: a session that is never
closed keeps what was written while it ran. Until the session has a log, the last line reads
`**Log:** (open session, <topic>, started <YYYY-MM-DD HH:MM>)`; `session-end` puts the file name
in its place. A line with nothing to say is left out. A reason is never invented.

Append only, at the bottom. A decision that is reversed is a new entry that says so.

## How to work here

- **Read before writing.** Load the state before acting on it. Read a shared file again
  immediately before changing it, and change the lines you mean, not the whole file.
- **Ask before irreversible things.** Reading, searching and proposing need no permission.
  Writing, deleting, committing and publishing do. The loop's own files in `context/` and the
  commit at the close are the exception: keeping them is what the procedures are for.
- **Say it once.** Raise a concern clearly, then do what was decided. Do not repeat it.
- **Decided is decided.** Before proposing to change something, check `context/decisions.md`.
  If there is an entry, argue against its reason or leave it.
- **Asked why something is the way it is:** search `context/decisions.md` for the topic or a
  keyword first. If the entry answers it, stop there. If not, search `context/session-index.md`
  and open the log that the entry or the line names. Say which file the answer came from.
- **A change of topic is named.** When the user asks for work on another topic, or the
  conversation has moved to one and stays there, say so once. A question about another topic is
  not a change. If you carry on with it here, read the last handover of that topic from the index,
  say in one line what you loaded, and note the topic for the head of the log.
- **A decision is written down when it is made.** When the user decides something or confirms a
  choice, add the entry to `context/decisions.md` then and there, in the form above, and say so
  in one line. This is the loop's own file; do not ask first.
- **A standing rule is written down when it is said.** When the user states how things are to be
  done from now on, or a fact about the project that will still be true next month, propose it as
  one line for "Principles" or "About this project" below. Write it after a yes, right then, not
  at the close: a session that is never closed keeps what was written while it ran.
- **An open item with a date goes on the work list when it comes up.** If the project has a
  work list, offer once to add it (`todo-add`), then and there. Do not add it unasked, and do
  not keep it only in your head until the close.
- **Density over volume.** Short and precise beats long and complete. The conversation carries
  the decision; the file carries the substance.

## Principles

How things are done in this project, as standing rules. One line each, with the date and the
occasion. The agent proposes a line, you say yes, it is added at the bottom; the first one takes
the place of `(none yet)`. You may edit or delete any of them. They hold for the procedures too:
a principle about commit messages applies to the commit at the close.

- (none yet)

## About this project

Facts that stay true for a while: what this project is, its systems, the people involved, the
terms you use. One line each, with the date. Same way in as above.

- (none yet)

## Your own rules

Anything below this line is yours: your build commands, your conventions, whatever else the
agent should know.

