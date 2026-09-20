# Agent Registry

Which agent handles which topic. `/session-start` reads this before anything else.

| Agent | Role | Signature | Topics |
|-------|------|-----------|--------|
| Main | Everything | `main/main-signature.md` | all |

**One agent is the normal case.** With a single row the Topics column does nothing and
`/session-start` never asks — it loads this signature and says so.

---

## When you want a second role

Some work needs a different stance, not a different tool. A reviewer who is supposed to find
problems rather than help you build. Someone whose job is the customer's point of view, not the
system's.

**The reason to add one is a different direction of thinking, not a different task list.** One
working bottom-up from the requirements, one top-down from the goal, one outside-in from the
person who receives the result. Same model, different blind spots — and the blind spots are what
you are buying. A second agent with the same stance as the first is a second copy.

Run `/new-agent`. It asks two questions, tells you if the new one would just be a copy of an
agent you already have, and writes the signature, the directory and the row.

What you end up with:

| Agent | Role | Signature | Topics |
|-------|------|-----------|--------|
| Main | Building, implementation | `main/main-signature.md` | default |
| Review | Finding what breaks | `review/review-signature.md` | `review`, `audit` |

Then the chain does the work: **topic → agent → signature → scope.** You declare `review` when
the session starts, and the session loads that signature instead. It says which one it took.

`/session-start` then routes on the Topics column. Two things make this hold rather than drift:

- **The instance does not edit its own signature.** You do. An agent that can rewrite its own
  limits has none.
- **Switching mid-session is not a costume change.** It is a new session. An agent that loaded
  as one role and works as another has the wrong stance and the wrong scope, and nothing in the
  transcript says so.
