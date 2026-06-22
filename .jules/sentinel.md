## 2024-06-22 - Data Leak via Asynchronous Process Temporary Files
**Vulnerability:** Clipboard contents were saved to `/tmp` and passed to an asynchronous `systemd-run` process without cleanup, leaking sensitive clipboard data to disk indefinitely.
**Learning:** When passing temporary files to asynchronous processes (like systemd-run), standard synchronous cleanup (like a `trap EXIT`) fails because the parent script exits before the async process finishes, and omitting cleanup leaves data behind.
**Prevention:** Use `${XDG_RUNTIME_DIR:-/tmp}` for temporary files to leverage in-memory tmpfs, and wrap asynchronous commands in a shell execution that explicitly removes the file after the primary command completes (e.g., `bash -c 'cmd "$1"; rm -f "$1"' _ "$FILE"`).
