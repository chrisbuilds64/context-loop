# Changelog

What changed in each version, in the words of someone who uses it. Newest first.

An update never touches your own files: `context/rules.md`, your logs, your project state, your
decisions and your work list stay as they are. Where a version brings something new for the rules
file, `/session-start` asks once before it adds anything.

The version you have is the one the plugin page shows. With the file packages it is the one you
downloaded.

---

## 1.5.2 — unreleased

- **The start tells you when a newer version is out,** in one line, with the clicks that get it
  in the tool you are using. Before, the Claude app stayed on an old version until its
  marketplace was checked by hand, and nothing said so.
- For that, `/session-start` reads one public file, the version number in this repository, once
  per start. Nothing of your project is sent. `update-check: no` in the settings of your rules
  file turns it off.
- The README has a section "Updating" with the way for each tool.
- The README names a project on your folder as the way to use Context Loop in the Claude app:
  the project keeps the folder, so you do not add it to every chat.

**To get this version in the Claude app:** Customize → Plugins → the marketplace context-loop →
Check for updates, then start a new chat.

## 1.5.1 — 2026-11-26

From the first run of 1.5.0 by someone who does not write software.

- **The first run asks in plain words.** "Where should it start when it gets a task: from the
  details, from the goal, or from the person?" replaces bottom-up, top-down and outside-in.
  Every option says what it means.
- **"Not sure, pick for me."** The start suggests the starting point that usually fits your
  kind of work, and says which one it took.
- **Limits have a place.** You can say that the agent must not change anything outside the
  project folder, and must not do anything final without asking. Both go into its signature.
  They are instructions to the agent, not locks.
- **It says once what a signature is,** and why the questions matter, before it asks.
- **No internal words in the chat.** What the agent tells you while it works is said in plain
  words.
- The README says where to add the folder in the Claude app.

## 1.5.0 — 2026-11-26

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
- **The first run asks one question less.** The topic of the first session is taken from what
  you just said about the work.
- **A session log written afterwards no longer takes over the thread.** It is named
  `…-reconstructed`, says only what is known, and the next start picks up from the last log you
  closed yourself.
- **A session in which nothing happened leaves no log.** It is closed with one line, so it
  cannot stand between you and your last real handover.
- **Something you want to do later is kept when you say it:** offered for the work list, or
  noted under "Next".
- **A project with one topic is not asked for the topic.**
- **A handover holds only what is true.** After a short session with nothing left open it says
  so, instead of inventing an open question.

**For an existing project:** the next `/session-start` asks once which way you want decisions
kept: written the moment they are made, or at the end of the session as before. Your answer is
noted as `decisions-written` in the settings of your rules file, and you are not asked again.
You can change that line at any time.

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
