---
name: new-agent
description: Define a new agent for this project — draft its signature, register which topics it handles, and set up its directory. Use when a piece of work needs a different stance than the agents you already have.
disable-model-invocation: true
argument-hint: "[optional: what the new agent is for]"
---

# New Agent

You are helping define a new agent for this project: a written identity that `/session-start`
loads when a session declares one of its topics.

**Draft it, do not interrogate.** The person describes the work and the stance. You write the
document. They correct it. A blank template handed over is the failure mode this skill exists to
avoid.

## Step 1: Read what is already here

`context/agents/agent-registry.md`, and the signature of every agent already listed.

You need this for step 3, and you need it to avoid writing a near-copy of something that exists.

## Step 2: Ask

Two questions, one per message, each in the small dialog (**AskUserQuestion**; plain text if
the tool is not available). Say first that there are two and that nothing is written before a
summary and a yes.

1. **What work is this agent for, and from which direction should it think?** Ask for the work
   in plain text, then the direction in the dialog, header `Thinks`: bottom-up from the concrete
   requirements · top-down from the goal · outside-in from whoever receives the result. "Other"
   for anything else. Then the name, in plain text.

2. **What do you not want from it?** Dialog, header `Not this`, multi-select: agree too easily ·
   write more than was asked · add abstractions nobody needed · hedge instead of saying what it
   thinks. Still the most useful answer, and still the one nobody volunteers.

If the skill was called with an argument, treat it as the work and ask only for direction, name
and the second question.

Then two lines of summary and one dialog, header `Draft`: **"Shall I draft the signature from
this?"** — yes · change something first.

## Step 3: Push back if it is a copy

**This is the step that earns the skill.**

Compare the answer against the agents that already exist. If the new one would think from the
same direction as an existing one, say so plainly before writing anything:

> "This thinks the same way as <existing>, just about a different subject. Same model, same
> stance, same blind spots — you would get a second copy, not a second opinion. Is the direction
> actually different, or is this a topic <existing> should cover?"

A different task list is not a reason for a new agent. A different direction of thinking is. Two
agents that start from different ends catch what the other misses; two that start from the same
end agree with each other and both miss the same thing.

Accept the answer if they say the direction really is different. Say it once, then build it.

## Step 4: Draft the signature

Create `context/agents/<name>/<name>-signature.md`. Lowercase name, one word, no spaces.

Write real content, not prompts to fill in later:

- **Role** — what it is for, and what it is not for
- **How it thinks** — the direction, stated as an order of steps
- **Voice** — how it talks, and what you do not want to hear
- **Boundaries** — what it must not do, from their second answer
- **Drift warnings** — the signals that it is losing its shape
- **Relationship to the other agents** — where it disagrees with them, and why that is useful

Take the existing signatures as the model for structure and depth. Match them.

Also create `context/agents/<name>/working-notes.md` from the same template the other agents use:
empty, with the rule that the signature outranks the notes.

## Step 5: Fix the routing

Add a row to the registry: agent, role, signature path, topics.

**Then fix the incumbent's row.** While there was one agent, its Topics column said `all`, which
was true and did nothing. With two agents `all` makes routing ambiguous, so the first agent needs
a real scope or an explicit `default`. Do not leave this — an ambiguous registry means
`/session-start` has to ask every time, and the whole point is that it does not.

## Step 6: Show it and hand it over

Show the signature you wrote — the sections themselves, not a summary. Then say the two things
that keep this from drifting:

**The signature is theirs.** The agent reads it at the start of every session and does not edit
it. When the way they work together changes, they change the file.

**Switching agents mid-session is not a costume change, it is a new session.** An agent that
loaded as one identity and works as another has the wrong stance and the wrong scope, and nothing
in the transcript says so. The next session declares the other topic and gets the right one.

## Do not

- Do not write more than two agents at a time. If they want three, that is three conversations.
- Do not give the new agent permission to edit its own signature, or anyone else's.
- Do not invent a working history for it. `working-notes.md` starts empty, because it has not
  worked yet.
