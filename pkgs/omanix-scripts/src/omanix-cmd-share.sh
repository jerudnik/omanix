#!/usr/bin/env bash

MODE="${1:-clipboard}"

case "$MODE" in
  clipboard)
    # SECURITY: Use XDG_RUNTIME_DIR (tmpfs) to avoid writing sensitive clipboard data to physical disk
    TMP=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/omanix-share-XXXXXX.txt")
    wl-paste > "$TMP"
    if [[ ! -s "$TMP" ]]; then
      notify-send "Share" "Clipboard is empty" -t 2000
      rm -f "$TMP"
      exit 1
    fi
    # SECURITY: Ensure temporary file is securely deleted *after* the asynchronous background process reads it
    systemd-run --user --quiet --collect sh -c 'localsend_app --headless send "$1"; rm -f "$1"' _ "$TMP"
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
