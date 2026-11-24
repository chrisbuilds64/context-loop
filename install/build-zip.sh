#!/bin/bash
# Build the four distributable ZIPs into dist/.
#
#   ContextLoop.zip           Claude Code: skills, hook, CLAUDE.md, the installer
#   ContextLoop-App.zip       Claude apps: context/, loop/, the instruction block
#   ContextLoop-OpenCode.zip  OpenCode: .opencode/, AGENTS.md, opencode.json
#   ContextLoop-Codex.zip     Codex and other AGENTS.md readers: context/, loop/, AGENTS.md
#
# The names carry no version: the release they are attached to does, and the README can then
# name the files once.
#
# All are for people who do not want the plugin, which is the recommended route and needs no
# build step at all — the marketplace serves this repository as it stands.
#
# Run this rather than zipping by hand: the payloads are assembled from the repository, the macOS
# metadata has to stay out, and the executable bit on the installer has to survive — a ZIP built
# in Finder carries __MACOSX noise and a download that will not run on double-click.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
DIST="$ROOT/dist"
mkdir -p "$DIST"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# --- Claude Code -------------------------------------------------------------
CC="$DIST/ContextLoop.zip"
mkdir -p "$STAGE/cc/pack"
"$HERE/assemble.sh" "$STAGE/cc/pack"
cp "$HERE/Install Context Loop.command" "$STAGE/cc/"
cp "$HERE/README.txt" "$STAGE/cc/"
chmod +x "$STAGE/cc/Install Context Loop.command"
rm -f "$CC"
( cd "$STAGE/cc" && zip -q -r -X "$CC" . -x '.DS_Store' -x '__MACOSX/*' )

# --- Claude apps -------------------------------------------------------------
APP="$DIST/ContextLoop-App.zip"
mkdir -p "$STAGE/app/ContextLoop"
"$HERE/assemble.sh" "$STAGE/app/ContextLoop" --app
rm -f "$APP"
( cd "$STAGE/app" && zip -q -r -X "$APP" . -x '.DS_Store' -x '__MACOSX/*' )

# --- OpenCode ----------------------------------------------------------------
OC="$DIST/ContextLoop-OpenCode.zip"
mkdir -p "$STAGE/oc/ContextLoop"
"$HERE/assemble.sh" "$STAGE/oc/ContextLoop" --opencode
rm -f "$OC"
( cd "$STAGE/oc" && zip -q -r -X "$OC" . -x '.DS_Store' -x '__MACOSX/*' )

# --- Codex and other AGENTS.md readers ----------------------------------------
CX="$DIST/ContextLoop-Codex.zip"
mkdir -p "$STAGE/cx/ContextLoop"
"$HERE/assemble.sh" "$STAGE/cx/ContextLoop" --agents
rm -f "$CX"
( cd "$STAGE/cx" && zip -q -r -X "$CX" . -x '.DS_Store' -x '__MACOSX/*' )

echo "Built:"
echo "  $CC"
echo "  $APP"
echo "  $OC"
echo "  $CX"
echo
echo "Check before shipping:"
echo "  - unzip the Claude Code one and confirm pack/.claude/skills holds all nine skills"
echo "  - confirm 'Install Context Loop.command' is still executable after unzipping"
echo "  - unzip the app one and confirm loop/ holds nine procedures and no .claude/ came along"
echo "  - unzip the Codex one and confirm loop/ holds nine procedures and AGENTS.md is at the top"
echo "  - unzip the OpenCode one and confirm .opencode/skills and .opencode/commands hold nine each"
echo "  - Gatekeeper blocks the downloaded .command on first run: System Settings >"
echo "    Privacy & Security > Open Anyway (macOS 15+); older systems: right-click > Open"
