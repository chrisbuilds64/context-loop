---
name: security-audit
description: Run a basic security audit of this repository — secrets in tracked files, .gitignore coverage, files that should never have been committed, dependency vulnerabilities, agent permission rules, MCP servers and the age of every API key. Writes a dated audit file with numbered findings. Run every 14 days; the session hook says when it is due.
disable-model-invocation: true
argument-hint: "[optional: quick | full]"
---

# Security Audit

A repository that an agent works in needs one more check than one that people work in alone:
the agent reads everything it can reach, and it writes what it is told to. This audit looks at
what is in the repository, what the agent has been allowed to do, what it is connected to, and
how old the keys are that it uses.

It runs in about ten minutes. It is deliberately basic. Every check here is one that has bitten
someone; nothing is here because it is theoretically possible.

**Cadence: every 14 days.** The session hook reports how old the last audit is. The date is in
the filename, so the age is visible without opening anything.

## Step 0: Load context

1. The newest file in `context/audits/` whose name ends in `_security-audit.md` — the previous
   audit. Its open findings carry forward and get re-checked.
2. `context/PROJECT-STATE.md` — anything under Debt or Blocked that is security-shaped.

If there is no previous audit, say so and start at SEC-001.

## Step 1: Checks

Run each one. Record PASS, WARN or FAIL with one line of detail. **Never print the value of a
secret** — report the file and the line number, not the content.

### 1.1 Secrets in tracked files

```bash
git ls-files -z | xargs -0 grep -nIE \
  '(sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|(api[_-]?key|secret|token|password)\s*[:=]\s*["'"'"'][^"'"'"']{8,})' \
  2>/dev/null | grep -v -E '(example|sample|placeholder|your[_-]|xxx|<.*>)' | cut -c1-120
```

Anything that is a real value is FAIL, regardless of whether the repository is private.
A private repository is one leaked token away from public.

### 1.2 Files that should never be tracked

```bash
git ls-files | grep -E '(^|/)\.env($|\.)|\.pem$|\.key$|\.p12$|\.pfx$|id_rsa|id_ed25519|\.htpasswd$|credentials\.json$|service-account.*\.json$'
```

Any hit is FAIL. `.env.example` with placeholder values is the one accepted exception — check
that it holds no real value.

### 1.3 .gitignore coverage

The file must exist and cover at least:

```
.env
.env.*
!.env.example
*.pem
*.key
secrets/
.claude/settings.local.json
```

Missing entries are WARN. A missing `.gitignore` is FAIL.

### 1.4 Git history

A secret that was committed and then deleted is still in the history. Quick check for files
that were ever added under a secret-shaped name:

```bash
git log --all --diff-filter=A --name-only --pretty=format: | sort -u | grep -E '(^|/)\.env($|\.)|\.pem$|\.key$|id_rsa|credentials\.json$'
```

A hit means the content is in the history even if the file is gone now. That is WARN at least,
FAIL if the value was real — and the remedy is **rotation, not history rewriting.** Rewriting
history is a second project; rotating the key takes five minutes and makes the leak worthless.

### 1.5 Dependencies

Find the manifests first, then scan what is there. **Do not report PASS for a scan that did not
run.** A check whose precondition was never true reports PASS forever and audits nothing.

```bash
find . -name node_modules -prune -o -name .git -prune -o \
  \( -name package-lock.json -o -name pnpm-lock.yaml -o -name yarn.lock \
     -o -name requirements*.txt -o -name pyproject.toml -o -name poetry.lock -o -name uv.lock \
     -o -name Cargo.lock -o -name go.sum -o -name Gemfile.lock -o -name pubspec.lock \) -print
```

| Found | Run |
|---|---|
| `package-lock.json` / `pnpm-lock.yaml` / `yarn.lock` | `npm audit --omit=dev` / `pnpm audit` / `yarn audit` in that directory |
| Python manifest | `pip-audit -r requirements.txt` or `pip-audit` inside the environment, if installed |
| any lockfile | `osv-scanner --lockfile <file>`, if installed — covers most ecosystems in one tool |

If the matching tool is not installed, the result is **NOT CHECKED**, with the install command
in the detail column. That is an honest result. PASS is not.

No manifests at all: PASS, "no dependencies to scan".

### 1.6 What the agent is allowed to do

`.claude/settings.json` and `.claude/settings.local.json` hold the permission rules. Read both.

- Rules that allow a whole tool without a pattern (`Bash`, `Bash(*)`) — WARN. One rule that
  allows everything is the absence of rules.
- Rules that carry hostnames, usernames, IPs or paths outside this project — WARN. They belong
  in a settings file that is not committed, and `settings.local.json` must be in `.gitignore`.
- Count the rules and note the number. A jump since the last audit is worth a look; rules
  accumulate one convenience at a time.

### 1.7 What the agent is connected to

`.mcp.json` in the project root, if it exists, lists MCP servers the agent can call.

List each server by name. Every one must be known: who added it, what it is for. A server nobody
can account for is FAIL — it is code that runs with the agent's reach. Servers that carry
tokens inline in the file are FAIL too; the token belongs in the environment.

No `.mcp.json`: PASS.

### 1.8 Key age

`context/key-inventory.md` lists every secret by name with the date it was last rotated.

- File missing or only the example rows: WARN. Ask for the list of keys the project uses and
  fill it in with the person — names and dates, never values.
- Any key with **Last rotated** more than 90 days ago: finding, severity MEDIUM, action
  "rotate". A key that was ever in a tracked file or in the history (1.1, 1.4): rotate now,
  regardless of age.
- Keys that are in the environment or in `.env` but not in the inventory: list them by name
  and add them. An unlisted key is an unrotated key.

Rotation is the measure that works after the leak you did not notice. It is cheap and boring,
and it is the one nobody does without a date next to it.

## Step 2: Carry forward

For every finding still OPEN in the previous audit, re-run its check:

- fixed → RESOLVED, one line on how
- still there → OPEN, carried forward with its original number and date
- accepted as risk → ACCEPTED, with who decided it and when

**A number is never reused and never deleted.** SEC-007 stays SEC-007 in every audit after it,
until it is resolved or accepted. That is what makes the series readable.

## Step 3: New findings

For every WARN or FAIL that is not already a known finding: next SEC number, severity, what it
is, what to do.

| Severity | Means |
|---|---|
| CRITICAL | a real secret in the repository or its history |
| HIGH | a file that should never be tracked, an unaccounted MCP server, an allow-all rule |
| MEDIUM | a dependency with a known vulnerability, a missing `.gitignore` entry |
| LOW | rules that carry details that belong elsewhere, hygiene |

When in doubt, rate higher.

## Step 4: Write the audit

Create `context/audits/<YYYY-MM-DD>_security-audit.md`:

```markdown
# Security Audit — <YYYY-MM-DD>

**Previous audit:** <date, or "none">
**Scope:** this repository

## Result

| Check | Result | Detail |
|---|---|---|
| 1.1 Secrets in tracked files | PASS/WARN/FAIL | |
| 1.2 Files that should never be tracked | | |
| 1.3 .gitignore coverage | | |
| 1.4 Git history | | |
| 1.5 Dependencies | PASS/WARN/FAIL/NOT CHECKED | |
| 1.6 Agent permissions | | <n> rules |
| 1.7 MCP servers | | |
| 1.8 Key age | | <n> keys, oldest <days>d |

## Resolved since last audit

- SEC-<nnn> — <how>

## Open

### SEC-<nnn> — <title>
**Severity:** <level> · **Since:** <date of first audit that found it>
**What:** <one or two sentences>
**Do:** <the concrete action>

## New

(same shape, or "None.")

## Next audit

<date + 14 days>
```

## Step 5: Update the state

In `context/PROJECT-STATE.md`, under Debt (or a Security heading if one exists): one line per
open finding with its number, and remove the ones resolved today.

## Step 6: Report

Short, in the conversation: counts of PASS / WARN / FAIL, the new findings, what needs a person
to act (rotating a key in a dashboard, deciding on an accepted risk), and the date of the next
audit.

---

## Rules

- **Never print a secret.** File and line, not content. Not even "to show what it looks like".
- **Rotate on suspicion.** If a value might have leaked, rotate it first and investigate second.
  The investigation takes an hour; the rotation takes five minutes and ends the exposure.
- **A check that did not run is NOT CHECKED, not PASS.**
- **Findings are permanent.** Numbers are never reused, never deleted, only resolved or accepted.
- No emoji unless asked for.
