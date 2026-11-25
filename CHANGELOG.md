# Changelog

What changed in each version, in the words of someone who uses it. Newest first.

An update never touches your own files: `context/rules.md`, your logs, your project state, your
decisions and your work list stay as they are. Where a version brings something new for the rules
file, `/session-start` asks once before it adds anything.

The version you have is the one the plugin page shows. With the file packages it is the one you
downloaded.

---

## 1.5.0 — unreleased

From the first test runs by people outside the team.

- **The start checks the folder first.** In an empty or temporary folder it says where it is and
  asks before it sets anything up. Before, a chat with no folder added got an empty workspace of
  its own, the start set it up without a word, and nothing carried over to the next chat.
- **You can correct the signature.** After the draft is shown, the first run stops and asks
  whether it is right. Before, it carried straight on into the session.
- **Decisions are written the moment they are made,** not at the close. A session that is never
  closed no longer loses them. `/session-end` fills in the name of the log afterwards.
- **A decision without a reason is written without one.** The form no longer expects a `Why`.
- **Rules and project facts are proposed when they are said,** not after the session is over.
- **No audit notice on day one.** A project younger than the audit interval is not told that no
  audit has run yet.
- **The starter files carry no old date.** The project state is dated on the day it is created.
- The README says that the folder has to be added to the chat, and that you start the procedures
  and the agent does not.

**For an existing project:** nothing to do. Your rules file keeps its text; the new behaviour
comes with the procedures.

## 1.4.0 — 2026-11-24

- **An index of all sessions,** one line each, built from the heads of the session logs. It
  repairs itself from the logs when a line is missing.
- **The thread is picked up per topic.** The start reads the last session on the topic you name,
  not simply the newest log.
- **A list of topics** with the other words each one has been called, so "homepage" and "website"
  find the same thread.
- **The project state is updated in place,** each line under its topic, so several sessions can
  keep it without overwriting each other.
- **Standing rules and project facts** have a place of their own in the rules file.
- The README names the limits and says what is checked by a program and what is only instructed.

## 1.3.0 — 2026-11-23

- **The start clears up sessions that were never closed.** It names each one, asks, and can
  rebuild a thin log from the traces, marked as a reconstruction.

## 1.2.0 — 2026-11-23

- **The language of the project is a setting.** The first answer decides it; rules, map, logs and
  what the agent says follow.
- **A session is not a chat.** The rules say so, and one chat may hold several sessions.

## 1.1.0 — 2026-11-23

- **`context/rules.md`:** how the loop behaves in your project is a file of yours. Where it
  differs from a procedure, it wins, and an update never overwrites it.
- **`context/README.md`** is the map of every file.
- A package for Codex and any tool that reads `AGENTS.md`.

## 1.0.0 — 2026-09-24

- **The work list:** `/todo`, `/todo-add`, `/todo-done`, with a schema and one guarded way in.
  Nine procedures in all.

## 0.2.0 — 2026-09-24

- **`/observe`:** keeps what you notice in the middle of a session.

## 0.1.0 — 2026-09-20

- First version: `/session-start`, `/session-end`, two audits, `/new-agent`, the template and the
  installer.
