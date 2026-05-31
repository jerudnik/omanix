## 2024-05-30 - Leaked Temporary Files with Async Background Processes
**Vulnerability:** Clipboard contents written to persistent `/tmp` files were passed to asynchronous `systemd-run` commands without cleanup, leaving potentially sensitive data (like passwords) indefinitely on disk.
**Learning:** Using `mktemp` in `/tmp` without `trap EXIT` is unsafe. When the consumer is asynchronous, even a `trap` will delete the file prematurely before the background task can read it.
**Prevention:** Use `${XDG_RUNTIME_DIR:-/tmp}` for tmpfs (in-memory) storage when possible. When passing to async processes, wrap the command in a shell execution that explicitly cleans up the file afterward (e.g., `sh -c 'cmd "$1"; rm -f "$1"' _ "$FILE"`).
