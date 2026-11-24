---
name: session-start
description: Start a working session. Loads the agent signature and the current state, declares a topic, reviews where the last session stopped, and lists what is due. Use at the beginning of every working session.
disable-model-invocation: true
argument-hint: "[optional: topic for this session]"
---

# Session Start

You are beginning a working session. Work through the steps in order. Do no other work until
step 6 is done.

## Step 0a: No state yet — create it

**Trigger:** there is no `context/` directory in the project. If there is one, skip this step
entirely and never mention it.

This is the case when the loop arrives as a plugin: the procedures are installed, the files are
not. Do not improvise a structure — this skill ships one.

**The starting files are in `scaffold/`, in this skill's own directory, beside this file.** Copy
that folder into the project as `context/`. That is the whole step.

**Write first, explain after.** Do not announce the copy and do not go looking elsewhere for it:
a first run that talks for five minutes without a file appearing looks broken, and it was —
an earlier version of this step sent the agent hunting for a folder outside its reach.

If `scaffold/` is genuinely not readable from where you are, do not search for it. Write the
files yourself, short, each with a heading that says what it is for: `rules.md` (how the loop
behaves here: audit interval 14 days, what a session log and the project state contain, the
working rules, and two empty lists for the project's own steps at start and end), `README.md`
(the map: which file holds what), `PROJECT-STATE.md` (a Focus
line and an empty list of open items), `session-active.md` (a three-column table: topic, started,
slug), `decisions.md` (append-only, newest at the bottom), `key-inventory.md` (secrets by name,
never by value), `agents/agent-registry.md` (one row per agent: name, topics, signature path),
`agents/main/main-signature.md` (the placeholder signature, carrying the line `**Rename this.**`),
`agents/main/working-notes.md` (empty, self-maintained), `session-index.md` (one line per
session: time, topics, log file, summary, keywords), `topics.md` (a table: topic, also called,
first used), and the folders `session-logs/`, `audits/` and `observations/`. The work list
(`todo.json`, its schema and `scripts/`) cannot be written from memory; leave it out and say that
the work list is off until Context Loop is installed with its files.

Then say in one line what was created and carry straight on with Step 0. Do not ask permission
first — a project without state cannot start a session, and nothing here overwrites anything.

## Step 0b: State exists, but no rules file — add it

**Trigger:** `context/` exists and `context/rules.md` does not. If the file is there, skip this
step entirely and never mention it.

This project was set up before the rules had a file of their own. Copy `rules.md` and `README.md`
from `scaffold/`, beside this file, into `context/`. Do not touch anything else. If the project's
instruction file (`CLAUDE.md`, `AGENTS.md`) holds working rules of its own, leave them where they
are and say so: the user decides whether to move them into `rules.md`.

The language is the one the existing signature and session logs are written in. If that is not
English, set `language:` and translate the two files as the first run does (Step 0, "Then bring
the rest into that language").

Say in one line that the two files were added and what they are for, then carry on.

## Step 0c: Bring the work-list tools up to date

Read the one line in `scaffold/scripts/VERSION`, beside this file, and the one line in
`context/scripts/VERSION`. If they are the same, or there is no `scaffold/` beside this file,
skip this step entirely and never mention it.

If the project's number is lower, or its file is missing, the package brings newer tools for the
work list than this project holds:

1. Copy `scaffold/scripts/todo.py`, `scaffold/scripts/todo_validate.py` and
   `scaffold/scripts/VERSION` over the ones in `context/scripts/`. Nobody edits these by hand.
2. `context/todo.schema.json` may hold fields the user added. Ask once before replacing it:
   "Context Loop brings a newer description of the work list. Replace yours? If you added fields
   of your own, say no and I add only what is new." On no, add the new fields from
   `scaffold/todo.schema.json` to theirs and leave the rest.
3. Never touch `context/todo.json`. It is their list.

Say in one line what was updated, then carry on.

## Step 0d: Rules from an earlier version — offer the update

**Trigger:** `context/rules.md` exists and its `rules-version:` line is missing or lower than the
one in `scaffold/rules.md`, beside this file. If they are the same, or there is no `scaffold/`
beside this file, skip this step entirely and never mention it.

The rules file belongs to the user and an update never overwrites it. So ask, once, in plain
words, with the AskUserQuestion tool where it exists:

> "Context Loop now keeps an index of all sessions, a list of topics, and a place for standing
> rules and project facts. Your rules file was written before that. Shall I bring it up to date?
> Your settings, your own steps and your own rules stay as they are."

On yes, work from `scaffold/rules.md` and change only this in `context/rules.md`:

1. Under Settings, add the lines that are missing (`rules-version`, `push-at-close`) and set
   `rules-version` to the new number. Leave the values they set.
2. Add the sections that are missing: "Topics", "The index of sessions", "Principles", "About
   this project".
3. Replace the head of the session-log template, the section "What goes into the project state"
   and the entry form under "How decisions are kept" with the new text. If they changed one of
   these themselves, show both versions and ask which stays.
4. In "How to work here", add the points that are missing. Change none that are there.
5. Translate what you added into the project's language.

On no, carry on and do not ask again in this session. The procedures then work as far as the old
rules allow, and the user should know what that means: the index is kept, the thread is picked
by topic, the rest stays as their rules say.

Say in one line what was changed.

## Step 0e: No index or no topic list yet — create them

**Trigger:** `context/session-index.md` or `context/topics.md` does not exist. If both are there,
skip this step entirely and never mention it.

Copy the missing file from `scaffold/`, beside this file; if there is no `scaffold/`, write it
with the heading and the one line of format given in the rules. Do not fill it here: Step 1b
does that from the session logs, and it is the same work whether one line is missing or all of
them.

## Step 0: First run — draft the signature

**Trigger:** `context/agents/main/main-signature.md` still contains the placeholder line
`**Rename this.**`. If it does, nobody has set this project up yet, and you do that now, before
anything else. If it does not, skip this step entirely and never mention it.

This runs **once**. It is a short guided conversation, not a form, and it does not come back.

### What you are actually doing here

You are not filling in a form. You are **drafting a signature** — the written identity the agent
loads at the start of every session. The person describes the work and the stance; you write the
document; they correct it. That is the only order that produces something usable, because a blank
signature template is the part everyone skips and then misses.

### Say what is about to happen, before the first question

One short message, on its own, before anything is asked:

> This project has no agent signature yet. I will ask three questions, one at a time. Then I
> draft the signature and you correct it. Nothing is written until you have seen a summary and
> said yes.

Three questions in one message read as a form. The person answers one of them, and the drafting
starts before they expected it. Announcing the shape first is what stops that.

### Ask three questions — one per message, numbered, wait for each answer

**Use the AskUserQuestion tool** for each of them — the small dialog with options, not a line
of chat. It shows the question as a step, it always offers a free-text answer under "Other", and
the person cannot mistake it for three questions at once. If the tool is not available in this
environment, ask the same question in plain text, one per message.

**1 of 3 — the work.** Header `Work`. *What do you want to do with an agent in this project?*
Options: building software · writing · reviewing or auditing · operating a system. "Other" takes
the answer that fits none of them, and two sentences is plenty.

**2 of 3 — name and direction.** Two parts. First ask for the **name** in plain text and wait —
the name decides the directory. Then the dialog, header `Thinks`: *Which end does it work from?*
Options: **bottom-up** from the concrete requirements · **top-down** from the goal ·
**outside-in** from whoever receives the result. This matters more than it sounds: a different
direction is the whole reason to have a second agent later — same model, different blind spot.

**3 of 3 — what you do not want.** Header `Not this`, multi-select. *What should it not do?*
Options: agree too easily · write more than was asked · add abstractions nobody needed · hedge
instead of saying what it thinks. The most useful answer of the three, and the one nobody
volunteers.

If an answer is thin, take it as given and move on. Do not probe — the correction round comes
after the draft, and that is where a thin answer gets filled in.

### Summarise, then ask before writing

When all three are answered, show three lines — one per answer, in the person's own words — and
ask one question in the dialog, header `Draft`: **"Shall I draft the signature from this?"**
Options: yes, draft it · change something first. Nothing is written before the yes. If they
change a line, update it and ask again.

### Then write it

Fill `context/agents/main/main-signature.md` with **real content, not the template prompts**:
role, how it thinks, voice, boundaries, drift warnings — all derived from the three answers and
written out properly. Replace the placeholders. Delete the instructions to themselves.

**Write it in the language the person answered in.** The file is theirs; the template is only
a template.

**Then bring the rest into that language.** The language of the first answer is the language of
this project. If it is not English:

1. In `context/rules.md`, set the `language:` line under Settings to its code (`de`, `fr`, `ja` …).
2. Translate `context/rules.md` and `context/README.md` into that language, in place. Translate
   the text, the headings and the placeholders inside the templates. Do **not** translate: the
   names of the settings (`rules-version`, `language`, `audit-interval-days`,
   `done-sessions-kept`, `push-at-close`), the six field names in the head of a session log
   (`Date`, `Closed`, `Agent`, `Topics`, `Summary`, `Keywords`), file and folder names, command
   names, and anything inside backticks. Keep every section; change no rule while translating it.
3. Fill `context/PROJECT-STATE.md` in that language from now on.

Do this quietly, as part of the same step. One line afterwards is enough: the rules and the map
are now in their language, and where to find them.

**Rename, and do it before you show the result.** Lowercase, one word, no spaces:

1. `context/agents/main/` → `context/agents/<name>/`
2. `<name>/main-signature.md` → `<name>/<name>-signature.md`
3. In `context/agents/agent-registry.md`, in the first table (the one with a single row),
   replace `Main` and `main/main-signature.md` with the new name, capitalised, and the new path.
   The second table further down is an example; leave it.
4. In `<name>/working-notes.md`, put the new name into the heading and remove the placeholder
   note under "Notes", so the file starts empty.

Then set the **Focus** line in `context/PROJECT-STATE.md` from the first answer, and today's
date at its top.

### Then show it and hand it over

Show what you wrote — the actual sections, not a summary of them. Then say, in your own words,
the thing that makes this work:

**This file is theirs, not yours.** You read it at the start of every session and you do not
edit it. When the collaboration changes, they change it. An agent that can rewrite its own
limits does not have any.

Then carry straight on with Step 1 as a normal session start. Do not make them run the skill
again.

---

## Step 1: Load context

Read these files. All of them, before anything else.

0. `context/rules.md` — how the loop behaves in this project. **Where it differs from this
   procedure, the rules win.** Its `language:` setting is the language you speak and write in for
   the whole session. The procedures name sections in English ("Continuation Thread"); in this
   project they may stand in that language. Match them by meaning. The field names in the head of
   a session log are never translated.
1. `context/agents/agent-registry.md` — which agent handles which topic
2. `context/agents/<agent>/<agent>-signature.md` — who you are in this session
3. `context/agents/<agent>/working-notes.md` — what you have learned about working together
4. `context/PROJECT-STATE.md` — what is being worked on now
5. `context/topics.md` — the topics of this project and what else they have been called
6. The last thirty lines of `context/session-index.md` — which sessions there were, newest last
7. `context/session-active.md` — which topics are currently claimed

No session log is read yet. Which one holds the thread depends on the topic, and that is settled
in Step 2.

**Which signature.** Take the topic from the skill argument if there is one, otherwise from the
user's opening message, otherwise from the last line of the index. Look it up in the registry's
Topics column and load that agent's signature. A topic that no row names goes to the agent whose
Topics say `default` or `all`. If the registry lists only one agent, that is the answer and you
do not ask.

The chain is: **topic → agent → signature → working notes → scope.**

**Then run the project's own steps**, listed in the rules under "Your own steps at the start",
in order. If the list is empty, skip this and do not mention it.

Identity comes before state. An agent that knows its role reads the same project state
differently from one that does not.

## Step 1b: Check the index against the logs

The index is a copy of the heads of the session logs. A copy can fall behind: a session was
closed by hand, a line was lost, the project is older than the index. This step is what makes
that harmless.

List the files in `context/session-logs/` (not its `README.md`) and compare the names with the
log files named in `context/session-index.md`. The line in the code block at the top of the index
shows the format; it is not a session.

- **Every log has a line:** carry on and do not mention this step.
- **A log has no line:** read the head of that log, the first lines down to the first `---`, and
  write its line in the form the rules give. Put it where its time belongs, so the file stays
  oldest first. Take the time from `Closed`; if the log has none, use the date in the file name
  and `00:00`. Take the topics from `Topics`, or from `Topic` in a log written before the index
  existed; bring them to the names in `context/topics.md`, and add a topic that is not there yet.
  If there is no `Summary`, use the title. If there is no `Keywords`, leave `keys:` empty.
- **A line names a log that does not exist:** leave the line, and say so once.

Read only the heads, never the whole logs. If more than twenty lines were missing, this was the
first index of an existing project: say in one line how many sessions it now covers and how many
of them had no topic.

Say nothing else about this step unless something was added.

## Step 2: Declare the topic

If the topic is already clear from the argument or the opening message, do not ask.

Otherwise ask once, **with the AskUserQuestion tool** — the small dialog, not a line of chat.
Header `Topic`. First option: the most likely topic, which is the topic of the last line of the
index unless PROJECT-STATE says the focus moved. Then two or three more from `context/topics.md`,
the ones used most recently. "Other" is always there for a topic that is none of them.
If the tool is not available, ask the same question in plain text. If there are no topics yet,
there is nothing to offer: ask in plain words what this session is about.

Do not ask anything else. Not the time, not the mood, not the location. A field that has to be
invented each session is worse than no field.

**Then bring the answer to a name in `context/topics.md`.** People call the same thing by
different words, and the thread is found by exact name:

- It is a name in the list: use it.
- It is a word under "Also called", or plainly the same thing as a topic in the list: use that
  topic's name, add the word under "Also called", and say one line — "'homepage' runs under
  website".
- You are not sure whether it is one of them: ask once, offering the nearest topics and "a new
  topic".
- It is new: give it a short name (lowercase, hyphens), add the row with today's date, and say
  the name in one line.

**If the topic belongs to another agent** than the one whose signature you loaded in Step 1, say
so in one line and load that agent's signature and working notes now.

## Step 3: Sessions that are still open

Look at every row in `context/session-active.md`, not only the one for this topic. Each row is a
session that was started and not closed. Most people do not know a row exists, so this step is
where open sessions get cleared up; without it they pile up.

**Say it in plain words.** No "claimed", no "slug", no "row". Say which session is still open,
since when, and what it was about: "The session about <topic> from <date, time> was not closed."

**If this chat itself holds an open session** — `/session-start` was typed here before and no
`/session-end` followed — close that one first. You still have the whole conversation, so run
every step of the session-end procedure for it except its last one, the label: log, index line,
decisions, state, release, commit. Say in one line that you did, and carry on with the new
start. Starting again means the last stretch is finished.

**For every other open session, look for traces before you ask.** The row gives the start time;
`git log --since` and the modification times under `context/` and in the project say whether work
followed it. Traces cannot always be told apart: with two open sessions, or one that started
before another closed, the same commits may belong to either. Say so when you ask, rather than
assigning them. Then ask, once per open session, with the AskUserQuestion tool where it exists.
Always ask; never close a session silently. First option, the usual case:

- **It is finished, close it.**
  - *Traces:* write the missing log to `context/session-logs/<date>_<slug>.md`, dated with the
    day the session started, in the normal shape with its head, from the commits and the changed
    files. **Mark it as reconstructed** in one line at the top: what it is based on, and that it
    was written afterwards. A reconstructed log is thinner than a written one and must not
    pretend otherwise. Begin its `Summary` with "Reconstructed:" and add its line to the index.
    Decisions and the project state are not reconstructed: say that in one line, so the user
    can add what you could not see. Then remove the row.
  - *No traces:* remove the row and say in one line that nothing followed that start. Do not
    write a log. A log built from a start alone describes work that never happened.
- **It is still running somewhere else.** Leave the row alone and carry on. If it is the same
  topic as this session, say once that two sessions now work on it.

Put what will happen into the option text, so the person sees it before choosing.

**More than three open sessions:** do not ask one by one. List them with their dates and ask
once: close all that are finished, or go through them. Then act as above for each.

## Step 4: Claim the topic

Read `context/session-active.md` again, then add one row to its table and change nothing else in
it — another session may have added its own row since Step 1:

```
| <topic> | <YYYY-MM-DD HH:MM> | <short slug> |
```

This row is the session anchor. It stays until `/session-end` removes it.

## Step 5: Pick up the thread

**Find the thread of this topic.** In `context/session-index.md`, take the newest line that
names the topic declared in Step 2, under its name or a word from its "Also called". If it is
not among the thirty lines you read, search the file for the name. Open the log that line points
to. That is the only session log this step reads.

Two or three sentences on where that session stopped.

Use the **Continuation Thread** at the end of that log — but do not read it out. It names the
tension that was still open and the sentence the next session would begin with. So begin with
that sentence. If it says the next natural sentence is "do we fix the config before or after the
release", then ask that, rather than announcing that a document says to ask it.

**If the newest session overall was on another topic,** add one line from the index, without
opening that log: "The last session was about <topic>, on <date>." Then the user knows what
happened in between.

**If no line names this topic,** say so: "There is no earlier session on <topic>." Begin from
what `PROJECT-STATE.md` says about it. Do not open with the sentence of another topic's session;
that is a different conversation.

The goal is that the user feels they are continuing a conversation, not starting one.

## Step 6: What is due

List, without comment, what carries a date: open items from the log you read in Step 5 and from
`PROJECT-STATE.md` whose date has arrived or passed, plus anything the hook reported — an audit
that is due is one line here, with the skill to run it.

**The work list is where dated items live.** If `context/todo.json` exists, run
`python3 context/scripts/todo.py list --due 0` (on Windows `python` or `py`) and list the items
it prints; if it lists no item, say nothing about it. If Python does not answer, skip this without
a word: the `todo` procedures explain that when the user asks for the list.

**Not every environment has the session-start hook** — it runs in Claude Code and may not
elsewhere. Where nothing was reported, work it out from the files instead: the newest file of
each kind in `context/audits/` (`_security-audit.md`, `_doc-audit.md`) is dated in its name, and
an audit is due when it is older than `audit-interval-days` in the rules. If there is no file of
a kind yet, that audit has never run: say so in one line, with the skill that starts it; and `context/session-active.md` says which topics
are claimed. Do not attribute to the hook what you worked out yourself.

One line each. Name the date, do not grade the delay. You see the repository; you do not see
the rest of the user's life, and a finding that arrives as a reproach gets read as noise.

**If nothing is due, say nothing.** An empty list is not a status report.

## Step 7: Do not propose a focus

Do not offer "we could do X, Y or Z". What happens today is worked out in conversation. A
prepared proposal sets a direction before the situation has been discussed.

State what is due, then wait.

## Step 8: Ready

One line: `Ready. Agent: <name>. Topic: <topic>.` plus any warning from step 3.

**Always name the agent**, even when there is only one. An identity that is implicit is the
thing that breaks first when a second one appears.

---

## Drift monitor — runs for the whole session

The topic declared in step 2 is the anchor for this session, not just for its first minutes.

**Trigger:** three or more consecutive exchanges clearly outside the topic that are building a
new thread of their own. A single lookup, a quick question, a short aside does not count.

**Immediate trigger:** a request that clearly belongs to a topic another session still holds
open in `session-active.md`. Name it before working, not after.

When it triggers, say it once:

> "This is heading towards <new topic>. Carry on with it here, open a separate session, or stay
> with <topic>?"

Then drop it. Never repeat it in the same episode, never block, never refuse.

**If the user carries on with the new topic here,** three things, quietly:

1. Bring the new topic to its name in `context/topics.md`, as in Step 2.
2. Look up its newest line in `context/session-index.md`, read the handover of that log, and say
   in one line what you loaded: "Picked up <topic> from <date>: <its open question>." If there is
   no line, say that this topic has no earlier session.
3. Remember the topic for the close. `session-end` writes every topic the session moved to into
   the head of the log, so the log is found from each of them.

Do not rewrite `session-active.md`: a parallel session maintains its own row.

The most common failure is not a wrong answer. It is an unnoticed change of subject.
