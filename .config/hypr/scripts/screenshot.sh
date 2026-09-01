#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +%Y%m%d-%H%M%S).png"

if ! GEOM=$(slurp); then
  exit 0
fi

grim -g "$GEOM" "$FILE"
wl-copy < "$FILE"

action=$(notify-send \
  --app-name="Screenshot" \
  --icon="$FILE" \
  --action=default="Markup" \
  "Screenshot copied to clipboard" \
  "Saved at $FILE" 2>/dev/null || true)

if [ "$action" = "default" ]; then
  swappy -f "$FILE"
fi
