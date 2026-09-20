
---

## In this environment

This copy of the procedure runs in a Claude app rather than in a terminal, so two of its
assumptions need correcting as you read it:

- **There is no session-start hook here.** Where the procedure says the hook reports something,
  work it out from the files instead — the newest file in `context/audits/` tells you whether an
  audit is due, and `context/session-active.md` says which topics are claimed.
- **Commit only if the project folder is a git repository.** If it is not, say so once and carry
  on. Do not mention it again.

If there is no `context/` folder in the project, the loop has not been set up here. Say so and
offer to create the structure rather than guessing at it.
