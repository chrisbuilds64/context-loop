#!/bin/bash
# Build the distributable ZIP.
#
# Run this rather than zipping by hand: the payload has to be assembled from the repository,
# the macOS metadata has to stay out, and the executable bit on the installer has to survive —
# a ZIP built in Finder carries __MACOSX noise and a download that will not run on double-click.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
VERSION="${1:-$(date +%Y-%m-%d)}"
OUT="$ROOT/ContextLoop-$VERSION.zip"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/pack"
"$HERE/assemble.sh" "$STAGE/pack"

cp "$HERE/Install Context Loop.command" "$STAGE/"
cp "$HERE/README.txt" "$STAGE/"
chmod +x "$STAGE/Install Context Loop.command"

rm -f "$OUT"
( cd "$STAGE" && zip -q -r -X "$OUT" . -x '.DS_Store' -x '__MACOSX/*' )

echo "Built $OUT"
unzip -l "$OUT" | tail -n +4 | head -20

echo
echo "Check before shipping:"
echo "  - unzip it somewhere and confirm pack/.claude/skills holds all five skills"
echo "  - confirm 'Install Context Loop.command' is still executable after unzipping"
echo "  - on a machine that downloaded it, Gatekeeper blocks the first run: System Settings >"
echo "    Privacy & Security > Open Anyway (macOS 15+); older systems: right-click > Open"
