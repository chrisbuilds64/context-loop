---
name: doc-audit
description: Run a basic documentation audit — checks that the context files still describe reality, that session logs are complete, that links and paths in CLAUDE.md and the docs still resolve, and that nothing dated has quietly passed. Writes a dated audit file. Run every 14 days; the session hook says when it is due.
disable-model-invocation: true
argument-hint: "[optional: quick | full]"
---

# Documentation Audit

The loop works only while the files tell the truth. A `PROJECT-STATE.md` that is a month behind
the last session log, a signature that still holds the template text, a `CLAUDE.md` that points
at a directory that was renamed — each of these is read at the start of every session and each
one steers the agent wrong without any error.

This audit checks the files the loop depends on first, then the rest of the project's
documentation. It fixes what is cheap and unambiguous, and lists what needs a person.

**Cadence: every 14 days.** The session hook reports the age of the last audit.

## Step 0: Load context

1. The newest `context/audits/*_doc-audit.md` — the previous audit. Open findings carry forward.
2. `context/PROJECT-STATE.md`, the newest session log, `context/session-active.md`.

## Step 1: The loop's own files

These come first because they are read every session.

### 1.1 State against history

`PROJECT-STATE.md` carries an **Updated** date. The newest session log carries a date in its
filename. If the state is older than the last log, the last session did not update it — finding,
and fix it now from that log.

"Done — last two sessions" must name the two newest logs. Older entries move out.

### 1.2 Claimed topics

Every row in `context/session-active.md` is either a live session or a session that ended
without `/session-end`. Only the person knows which. List the rows with their dates and ask;
do not delete them yourself.

### 1.3 Session logs

For every file in `context/session-logs/`:

```bash
ls context/session-logs/2*.md 2>/dev/null | while read -r f; do
  grep -q '^## Continuation Thread' "$f" || echo "no continuation thread: $f"
  grep -q '^\*\*Topic:\*\*' "$f" || echo "no topic: $f"
done
```

A log without a Continuation Thread has no handover in it. It cannot be written after the fact
— note it, and check that the *next* session's log did not start from nothing.

Filenames must be `YYYY-MM-DD_slug.md`. One that is not sorts in the wrong place.

### 1.4 Signatures and registry

- Every signature file must be free of the template placeholders (`**Rename this.**`,
  `<One or two sentences`, `<e.g.`). A placeholder that survived is a signature nobody wrote.
- Every row in `context/agents/agent-registry.md` must point at a file that exists.
- Every directory under `context/agents/` must have a row in the registry.
- Every entry in a `working-notes.md` must carry a date. An undated note is an opinion.

### 1.5 Dates that have passed

```bash
grep -rnoE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' context/PROJECT-STATE.md
```

Any date in the past next to an open item (`- [ ]`) is listed. Not graded — named. The person
decides whether it was missed or moved.

## Step 2: The project's documentation

### 2.1 Paths in CLAUDE.md

Every path CLAUDE.md mentions must exist:

```bash
grep -oE '`[^`]+`' CLAUDE.md | tr -d '`' | grep -E '^[A-Za-z0-9_./-]+$' | grep -E '/|\.' \
  | grep -vE '^/[a-z0-9-]+$' | sort -u | while read -r p; do
  [ -e "$p" ] || echo "missing: $p"
done
```

Skill names (`/session-start`) are filtered out; they are not paths. CLAUDE.md is read before
anything else, and a wrong path there is a wrong instruction in every session.

### 2.2 Links in markdown

Relative links in every tracked `.md` file must resolve. The skill files under `.claude/` are
skipped — their code blocks contain link-shaped text that is not a link:

```bash
git ls-files '*.md' | grep -v '^\.claude/' | while read -r f; do
  d=$(dirname "$f")
  grep -oE '\]\([^)#]+' "$f" | sed 's/](//' | grep -vE '^(https?:|mailto:)' | while read -r l; do
    [ -e "$d/$l" ] || [ -e "$l" ] || echo "$f -> $l"
  done
done
```

### 2.3 Stale documents

Tracked `.md` files not changed in 60 days:

```bash
git ls-files '*.md' | while read -r f; do
  t=$(git log -1 --format=%ct -- "$f" 2>/dev/null); now=$(date +%s)
  [ -n "$t" ] && [ $(( (now - t) / 86400 )) -ge 60 ] && echo "$(( (now - t) / 86400 ))d  $f"
done | sort -rn
```

Old is not wrong. List them; open the ones that describe something that has changed. Do not
bump a date on a file whose content was not touched — a fresh date on stale content is the worst
of both.

### 2.4 Contradictions (full only)

Read the top-level README and CLAUDE.md side by side with `PROJECT-STATE.md`. Where two of them
describe the same thing differently — a command, a directory, a status — that is a finding, and
the one that matches the repository wins.

## Step 3: Classify

| Level | Means |
|---|---|
| HIGH | steers the next session wrong: wrong path in CLAUDE.md, state older than the last log, unfilled signature |
| MEDIUM | a broken link, a log without a thread, a registry row with no file |
| LOW | stale but correct, cosmetic |

Findings are numbered per audit (1, 2, 3 …), not across audits.

## Step 4: Fix what is cheap

Fix in this session, without asking: a stale Updated date on `PROJECT-STATE.md` when the log
says what happened, a broken relative link whose target obviously moved, a missing registry row
for a directory that exists.

Ask before: deleting anything, rewriting a signature, removing a claimed topic, changing a
status the person set.

## Step 5: Write the audit

Create `context/audits/<YYYY-MM-DD>_doc-audit.md`:

```markdown
# Documentation Audit — <YYYY-MM-DD>

**Previous audit:** <date, or "none">
**Scope:** quick | full

## Findings

| # | Level | Where | What | Status |
|---|---|---|---|---|
| 1 | HIGH | `CLAUDE.md` | path `docs/old/` does not exist | fixed |
| 2 | MEDIUM | `context/session-logs/2026-02-03_x.md` | no Continuation Thread | open — cannot be written after the fact |

## Carried forward from <previous date>

- <finding> — resolved / still open / deferred

## Stale (60+ days, not graded)

- <age>  <file>

## Next audit

<date + 14 days>
```

## Step 6: Report

Short: how many findings, which were fixed, what needs the person, next audit date.

---

## Rules

- **Fix what is stale, do not restructure.** A documentation audit that reorganises the docs is
  a different project, and it needs asking first.
- **Do not invent dates.** Bump Updated only when content was actually changed.
- **Every open finding from the last audit gets a verdict** — resolved, still open, deferred.
  Silence is how findings get lost.
- No emoji unless asked for.
