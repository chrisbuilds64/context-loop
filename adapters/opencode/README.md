# The OpenCode adapter

OpenCode finds the procedures by itself: a skill under `.opencode/skills/` is loaded and offered
to the model as a tool. What it does **not** do is put them in the slash menu — that menu lists
commands, and a skill is not one. Measured in the TUI on 2026-09-25: only `source=command`
entries appear when you type `/`.

So this directory holds the wiring:

- **`commands/*.md`** — one three-line command per procedure. Each one calls its skill by name and
  passes `$ARGUMENTS` through. This is what makes `/observe` and `/session-end` exist for the
  person rather than only for the model.
- **`commands/session-start.md`** additionally embeds the state with `` !`shell` ``, because
  OpenCode has no session-start event. The TUI runs embedded shell at invocation time.
- **`opencode.json`** — points at `AGENTS.md`, which is the same text Claude Code reads as
  `CLAUDE.md`. `assemble.sh` writes it under the name the environment expects.

`` !`shell` `` is expanded in the TUI and **not** in `opencode run`. A headless run therefore
starts without the state block; the procedure reads the same files anyway, it just has nothing
handed to it first.
