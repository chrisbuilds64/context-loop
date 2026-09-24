---
name: observe
description: Capture something the work just taught you — friction, a near miss, a decision that turned out to rest on nothing — as one structured file in context/observations/. Use mid-session, when you notice it, not at the end.
disable-model-invocation: true
argument-hint: "[what you noticed, in your own words — or nothing, and I work it out from the session]"
---

# Observe

`/session-start` loads the state and `/session-end` writes the handover. This is the one in the
middle: the thing you notice at 14:20 and cannot reconstruct at 19:00.

**Two minutes, one file, and permission to say no.** Most of what happens in a session is not
worth a file. The skill that captures everything is the skill nobody runs twice.

## Step 1: Read the signal

If the skill was called with an argument, that is the observation, in their words. Keep their
words — you are structuring what they saw, not improving it.

If it was called with nothing, look back over the session and name the one moment worth keeping.
Say which one you picked and why, in a sentence, before you write anything. They will correct you
if you picked the wrong one, and that correction costs five seconds.

Do not interpret yet. Do not tidy it into a lesson.

## Step 2: Decide whether this is worth a file

**This is the step that earns the skill.** Everything else is a form.

Worth keeping:

- Friction that points at something structural, not at one bad afternoon
- A gap in who decides what, that caused confusion or a redo
- A decision whose reasoning will be invisible in three months
- A moment where somebody overruled the agent and was right
- Behaviour of a system that contradicts what its documentation says
- Something that worked unexpectedly well and nobody knows why

Not worth keeping:

- A bug with a fix and no wider lesson
- Anything already written down somewhere that is read
- Something true of today and of no other day

**If it does not clear the bar, say so and stop.** One sentence: *"I would not keep this — it is
a bug with a fix, not a pattern."* Then do nothing. A refusal here is the skill working, and a
directory of forty observations nobody reads is the skill having failed quietly.

If they disagree, write it. They were there and you were not.

## Step 3: Write the file

`context/observations/YYYY-MM-DD_short-slug.md`. Today's date. Three to five words in the slug,
naming the phenomenon rather than the fix — `agent-rebuilt-after-new-information`, not
`added-confirmation-step`.

```markdown
# Observation — YYYY-MM-DD

**Topic:** [the session topic this came out of]
**Signal:** [strong / worth keeping — if the second, one line on why you kept it anyway]

## Context

What was happening. Which system, which task, which moment. One short paragraph, and no verdict
in it yet.

## Observation

What happened. One sentence, empirical. "X did Y" — not "X means Y".

## Why it mattered

What would have gone wrong if nobody had noticed. Or what it explains that was confusing before.

## Structural implication

One level up from the incident. What does this say about how the system is put together, rather
than about this one run?

## Governance implication

Who decides, who checks, what the agent may do on its own. Write "None identified" when there is
none — that is an answer, not an empty field.

## Carry forward

Where this goes next, and it is one of three:

- **`decisions.md`** — it settled something, and the reasoning should survive the month
- **the agent's `working-notes.md`** — it is about how you and the agent work together
- **hold** — it is one of a kind so far, and a pattern may or may not form behind it

## Related

The part of the project this belongs to. Be specific enough that a search finds it.

## Temperature *(optional)*

One word, if it carries something a fact does not: frustrating · surprising · clarifying ·
unsettling · satisfying.
```

## Step 4: Report, short

Four lines, no more:

- the slug
- the structural implication, in one sentence
- what *Carry forward* says
- whether three or more observations now share a theme

**On that last one: say it, do not act on it.** A cluster is a suggestion. What becomes of it is
theirs to decide, and the file has already done its job by existing when that decision comes.

## Do not

- Do not write more than one observation per call. Two things noticed means two calls.
- Do not soften the observation into something presentable. The unresolved version is the useful
  one — a lesson that already knows its own moral was not learned here.
- Do not move or rewrite older observations. They record what was seen at the time, including
  where it later turned out to be wrong.
- Do not turn this into a log. If it runs every session, the bar in step 2 is too low.
