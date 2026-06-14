#!/usr/bin/env bash

# [Security] Use memory-backed tmpfs and pass argument instead of interpolation to avoid shell injection
HELP_FILE=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/omanix-help-XXXXXX.md")
sed "s/{{THEME_LIST}}/$OMANIX_THEME_LIST/" "$OMANIX_DOC_STYLE" > "$HELP_FILE"

if command -v glow &> /dev/null; then
  ghostty --class="org.omanix.terminal" -e sh -c 'glow -p "$1"; rm -f "$1"' _ "$HELP_FILE"
else
  ghostty --class="org.omanix.terminal" -e sh -c 'less "$1"; rm -f "$1"' _ "$HELP_FILE"
fi
