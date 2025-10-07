#!/usr/bin/env bash
set -euo pipefail
TITLE="${*:-New Puzzle}"
SLUG="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g;s/^-|-$//g')"
DATE="$(date +%Y-%m-%d)"

# find next day number by counting existing day-* dirs
cd puzzles
LAST=$(ls -d day-* 2>/dev/null | sed -E 's/^day-([0-9]{3}).*/\1/' | sort -n | tail -n1)
if [[ -z "${LAST:-}" ]]; then NEXT=1; else NEXT=$((10#$LAST + 1)); fi
DAY=$(printf "%03d" "$NEXT")
DIR="day-${DAY}-${SLUG}"

# copy template
cp -r _templates "$DIR"

# replace placeholders
sed -i "s/{{TITLE}}/${TITLE}/g; s/{{DAY}}/${DAY}/g; s/{{DATE}}/${DATE}/g" "$DIR/README.md"
sed -i "s/{{TITLE}}/${TITLE}/g" "$DIR/bolt-site/index.html"

echo "✅ Created puzzles/${DIR}"
echo "   - bolt-site/"
echo "   - n8n-workflow/"
echo "   - assets/"
