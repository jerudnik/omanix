## 2024-06-17 - Prevent clipboard info disclosure on disk
**Vulnerability:** Clipboard content was temporarily saved to `/tmp` (physical disk by default on many setups) for sharing via localsend, but the script did not reliably clean up the file, nor did it ensure `tmpfs` usage.
**Learning:** Using `mktemp` with a specific `/tmp/...` prefix without ensuring it's a `tmpfs` (like `XDG_RUNTIME_DIR`) and without reliable cleanup after asynchronous commands leaves sensitive clipboard data indefinitely on disk.
**Prevention:** Always prefer `${XDG_RUNTIME_DIR:-/tmp}` for temporary files, and wrap asynchronous commands (like `systemd-run --user`) with a shell command that ensures file deletion after execution (e.g., `sh -c '...; rm -f "$1"' _ "$TMP"`).
