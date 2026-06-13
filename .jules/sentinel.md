## 2024-05-24 - Initial Setup
**Vulnerability:** N/A
**Learning:** Initializing Sentinel journal.
**Prevention:** N/A

## 2024-05-24 - Clipboard Data Leak via Persistent Temp File
**Vulnerability:** Clipboard contents were saved to a persistent temporary file (`/tmp/omanix-share-XXXXXX.txt`) and passed to an asynchronous `systemd-run` command without any cleanup mechanism.
**Learning:** When passing temporary files to asynchronous processes (like `systemd-run --collect`), the calling script cannot rely on a standard script trap or sequential removal since it exits immediately.
**Prevention:** Use an in-memory file via `${XDG_RUNTIME_DIR:-/tmp}` and wrap the asynchronous command with `sh -c 'command "$1"; rm -f "$1"' _ "$TMP"` to ensure cleanup happens after the background command completes.
