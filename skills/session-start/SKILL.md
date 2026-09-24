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
files yourself, short, each with a heading that says what it is for: `PROJECT-STATE.md` (a Focus
line and an empty list of open items), `session-active.md` (a three-column table: topic, started,
slug), `decisions.md` (append-only, newest at the bottom), `key-inventory.md` (secrets by name,
never by value), `agents/agent-registry.md` (one row per agent: name, topics, signature path),
`agents/main/main-signature.md` (the placeholder signature, carrying the line `**Rename this.**`),
`agents/main/working-notes.md` (empty, self-maintained), and the folders `session-logs/`,
`audits/` and `observations/`.

Then say in one line what was created and carry straight on with Step 0. Do not ask permission
first — a project without state cannot start a session, and nothing here overwrites anything.

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

**Rename, and do it before you show the result.** Lowercase, one word, no spaces:

1. `context/agents/main/` → `context/agents/<name>/`
2. `<name>/main-signature.md` → `<name>/<name>-signature.md`
3. In `context/agents/agent-registry.md`, replace `Main` and `main/main-signature.md` in the
   table row with the new name and path.

Then set the **Focus** line in `context/PROJECT-STATE.md` from the first answer.

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

1. `context/agents/agent-registry.md` — which agent handles which topic
2. `context/agents/<agent>/<agent>-signature.md` — who you are in this session
3. `context/agents/<agent>/working-notes.md` — what you have learned about working together
4. `context/PROJECT-STATE.md` — what is being worked on now
5. The newest file in `context/session-logs/` — where the last session stopped
6. `context/session-active.md` — which topics are currently claimed

**Which signature.** Take the topic from the skill argument if there is one, otherwise from the
user's opening message, otherwise from the `Topic:` field of the newest session log. Look it up
in the registry's Topics column and load that agent's signature. If the registry lists only one
agent, that is the answer and you do not ask.

The chain is: **topic → agent → signature → working notes → scope.**

Identity comes before state. An agent that knows its role reads the same project state
differently from one that does not.

## Step 2: Declare the topic

If the topic is already clear from the argument or the opening message, do not ask.

Otherwise ask once, **with the AskUserQuestion tool** — the small dialog, not a line of chat.
Header `Topic`. First option: the most likely topic, which is the `Topic:` of the newest session
log unless PROJECT-STATE says the focus moved. Then two or three alternatives taken from the open
items in `context/PROJECT-STATE.md`. "Other" is always there for a topic that is none of them.
If the tool is not available, ask the same question in plain text.

Do not ask anything else. Not the time, not the mood, not the location. A field that has to be
invented each session is worse than no field.

## Step 3: Check for collisions

Look at `context/session-active.md`. If another session already holds this topic, say so and
give the time it was claimed. Do not refuse — an entry that was never released looks exactly
like a live session, and only the user knows which it is.

### If the user says that session is over, repair it rather than mourn it

A claimed row with no session log for it means a session ended without being closed. The handover
is missing, not the work: the state, the decisions and the earlier logs are all still there. And
the row itself is the signal — undisciplined work without this loop does not even leave that.

Offer to reconstruct it, and do it if they say yes:

1. The row gives you the start time. Collect what happened after it: `git log --since` for the
   commits, and the modification times under `context/` and in the project for what changed.
2. Write the missing log to `context/session-logs/<date>_<slug>.md` in the normal shape, and
   **mark it as reconstructed** in one line at the top: what it is based on, and that nobody was
   asked. A reconstructed thread is thinner than a written one and must not pretend otherwise.
3. Remove the stale row, then claim your own.

If they say the session is still running elsewhere, leave the row alone and carry on.

## Step 4: Claim the topic

Add one row to the table in `context/session-active.md`:

```
| <topic> | <YYYY-MM-DD HH:MM> | <short slug> |
```

This row is the session anchor. It stays until `/session-end` removes it.

## Step 5: Pick up the thread

Two or three sentences on where the last session stopped.

Use the **Continuation Thread** at the end of the last session log — but do not read it out.
It names the tension that was still open and the sentence the next session would begin with.
So begin with that sentence. If it says the next natural sentence is "do we fix the config
before or after the release", then ask that, rather than announcing that a document says to ask
it.

The goal is that the user feels they are continuing a conversation, not starting one.

## Step 6: What is due

List, without comment, what carries a date: open items from the last session log and from
`PROJECT-STATE.md` whose date has arrived or passed, plus anything the hook reported — an audit
that is due is one line here, with the skill to run it.

**Not every environment has the session-start hook** — it runs in Claude Code and may not
elsewhere. Where nothing was reported, work it out from the files instead: the newest file in
`context/audits/` says whether an audit is due, and `context/session-active.md` says which topics
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

**Immediate trigger:** a request that clearly belongs to a topic another session already holds
in `session-active.md`. Name it before working, not after.

When it triggers, say it once:

> "This is heading towards <new topic>. Separate session, or are we staying with <topic>?"

Then drop it. Never repeat it in the same episode, never block, never refuse. If the user
confirms the drift is intentional, move your internal anchor and carry on — do not rewrite
`session-active.md`, because a parallel session maintains its own row.

The most common failure is not a wrong answer. It is an unnoticed change of subject.
