# Decisions

*One entry per decision, newest at the bottom. The agent adds an entry the moment a decision is
made; `/session-end` adds what is missing and fills in the name of the log. Apart from that one
line, an entry is never edited afterwards. Before proposing to change something that is
decided, the agent reads the entry — and argues against the reason, not against the decision.*

Why this file exists: a decision that lives only in a session log disappears by date, and one
that lives only in `PROJECT-STATE.md` is dropped once it is done. Three weeks later the agent
asks why it was built this way and reopens the discussion. This file is the answer.

It is not read in full at the start of a session. The topic in square brackets is what makes an
entry findable: search for the topic or a keyword, and follow `Log:` when the reason needs more
than three sentences.

Format:

```
## <YYYY-MM-DD> — [<topic>] <what was decided, one line>
**Why:** <the reason, one to three sentences, if one was given>
**Instead of:** <the alternative that was rejected, if there was one>
**Log:** <file name of the session log>
```

---
