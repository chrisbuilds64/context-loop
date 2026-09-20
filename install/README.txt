Context Loop
Your agent forgets. Your files don't.


INSTALL

1. Double-click  "Install Context Loop.command"
2. Pick where the project should go, and give it a name
3. Follow the three lines it prints at the end


IF MACOS BLOCKS IT

The first time, macOS will say the file is from an unidentified developer and
refuse to open it. That is Gatekeeper, and it says the same about everything
that is downloaded and not signed by a registered developer.

macOS 15 or newer: open System Settings > Privacy & Security and scroll to the
bottom. Next to the note about "Install Context Loop.command" click Open Anyway,
then confirm. The button only shows for about an hour after the blocked attempt.
If it is not there, double-click the file again and go straight back.

macOS 14 or older: right-click the file, choose Open, then confirm Open. Once.

If you would rather not run a script at all, you do not have to. Open a terminal
in this folder and run:

    cp -R pack/. /path/to/your/project/

The dot after pack/ is the whole point — without it the .claude folder is left
behind, and that folder is the pack. Then check:

    ls /path/to/your/project/.claude/skills

You should see five: session-start, session-end, security-audit, doc-audit
and new-agent.


WHY NOT JUST DRAG THE FOLDER

Because Finder does not show files that start with a dot, so select-all does not
select them. You would get a folder that looks complete, and /session-start would
not exist.


WHAT IS IN HERE

  Install Context Loop.command   the installer
  pack/                          the files it installs
  pack/README.md                 what the thing actually does


Licence: MIT. Do what you like with it.
