#!/bin/bash
# Build the two distributable ZIPs.
#
#   ContextLoop-<version>.zip       Claude Code: skills, hook, CLAUDE.md, the installer
#   ContextLoop-App-<version>.zip   Claude apps: context/, loop/, the instruction block
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

echo "Built:"
echo "  $CC"
echo "  $APP"
echo
echo "Check before shipping:"
echo "  - unzip the Claude Code one and confirm pack/.claude/skills holds all five skills"
echo "  - confirm 'Install Context Loop.command' is still executable after unzipping"
echo "  - unzip the app one and confirm loop/ holds five procedures and no .claude/ came along"
echo "  - Gatekeeper blocks the downloaded .command on first run: System Settings >"
echo "    Privacy & Security > Open Anyway (macOS 15+); older systems: right-click > Open"
