#!/usr/bin/env bash

MODE="${1:-clipboard}"

case "$MODE" in
  clipboard)
    TMP=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/omanix-share-XXXXXX.txt")
    trap 'rm -f "$TMP"' EXIT
    wl-paste > "$TMP"
    if [[ ! -s "$TMP" ]]; then
      notify-send "Share" "Clipboard is empty" -t 2000
      exit 1
    fi
    # Wait for the systemd-run process to complete so that trap can cleanup the temp file safely
    systemd-run --user --quiet --collect --wait localsend_app --headless send "$TMP"
    ;;
  file)
    FILES=$(find "$HOME" -type f 2>/dev/null | fzf --multi)
    [[ -z "$FILES" ]] && exit 0
    if echo "$FILES" | grep -q $'\n'; then
      readarray -t FILE_ARRAY <<< "$FILES"
      systemd-run --user --quiet --collect localsend_app --headless send "${FILE_ARRAY[@]}"
    else
      systemd-run --user --quiet --collect localsend_app --headless send "$FILES"
    fi
    ;;
  folder)
    FOLDER=$(find "$HOME" -type d 2>/dev/null | fzf)
    [[ -z "$FOLDER" ]] && exit 0
    systemd-run --user --quiet --collect localsend_app --headless send "$FOLDER"
    ;;
esac