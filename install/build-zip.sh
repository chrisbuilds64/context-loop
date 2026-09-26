#!/bin/bash
# Build the three distributable ZIPs.
#
#   ContextLoop-<version>.zip           Claude Code: skills, hook, CLAUDE.md, the installer
#   ContextLoop-App-<version>.zip       Claude apps: context/, loop/, the instruction block
#   ContextLoop-OpenCode-<version>.zip  OpenCode: .opencode/, AGENTS.md, opencode.json
#
# Both are for people who do not want the plugin, which is the recommended route and needs no
# build step at all — the marketplace serves this repository as it stands.
#
# Run this rather than zipping by hand: the payloads are assembled from the repository, the macOS
# metadata has to stay out, and the executable bit on the installer has to survive — a ZIP built
# in Finder carries __MACOSX noise and a download that will not run on double-click.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
VERSION="${1:-$(date +%Y-%m-%d)}"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# --- Claude Code -------------------------------------------------------------
CC="$ROOT/ContextLoop-$VERSION.zip"
mkdir -p "$STAGE/cc/pack"
"$HERE/assemble.sh" "$STAGE/cc/pack"
cp "$HERE/Install Context Loop.command" "$STAGE/cc/"
cp "$HERE/README.txt" "$STAGE/cc/"
chmod +x "$STAGE/cc/Install Context Loop.command"
rm -f "$CC"
( cd "$STAGE/cc" && zip -q -r -X "$CC" . -x '.DS_Store' -x '__MACOSX/*' )

# --- Claude apps -------------------------------------------------------------
APP="$ROOT/ContextLoop-App-$VERSION.zip"
mkdir -p "$STAGE/app/ContextLoop"
"$HERE/assemble.sh" "$STAGE/app/ContextLoop" --app
rm -f "$APP"
( cd "$STAGE/app" && zip -q -r -X "$APP" . -x '.DS_Store' -x '__MACOSX/*' )

# --- OpenCode ----------------------------------------------------------------
OC="$ROOT/ContextLoop-OpenCode-$VERSION.zip"
mkdir -p "$STAGE/oc/ContextLoop"
"$HERE/assemble.sh" "$STAGE/oc/ContextLoop" --opencode
rm -f "$OC"
( cd "$STAGE/oc" && zip -q -r -X "$OC" . -x '.DS_Store' -x '__MACOSX/*' )

echo "Built:"
echo "  $CC"
echo "  $APP"
echo "  $OC"
echo
echo "Check before shipping:"
echo "  - unzip the Claude Code one and confirm pack/.claude/skills holds all nine skills"
echo "  - confirm 'Install Context Loop.command' is still executable after unzipping"
echo "  - unzip the app one and confirm loop/ holds nine procedures and no .claude/ came along"
echo "  - unzip the OpenCode one and confirm .opencode/skills holds nine and .opencode/commands one"
echo "  - Gatekeeper blocks the downloaded .command on first run: System Settings >"
echo "    Privacy & Security > Open Anyway (macOS 15+); older systems: right-click > Open"
