## 2024-06-20 - [Sentinel Initialized]
**Vulnerability:** Initializing sentinel journal
**Learning:** How to journal
**Prevention:** Journal when needed

## 2024-06-20 - [Data Leakage via Async Background Processes]
**Vulnerability:** Clipboard contents written to a persistent `/tmp` file were leaked because the cleanup step was omitted when using an asynchronous background execution command (`systemd-run`).
**Learning:** Temporary files passed to asynchronous background processes (like `systemd-run` without `--wait` or `ghostty`) cannot rely on script-level synchronous cleanup. If the caller exits, the background process may still need the file, or if the background process never cleans it up, it persists.
**Prevention:** 1. Wrap async commands in a shell execution that includes cleanup (e.g., `sh -c 'cmd "$1"; rm -f "$1"' _ "$FILE"`). 2. Always prefer `${XDG_RUNTIME_DIR:-/tmp}` for sensitive temporary files to ensure they remain in memory (tmpfs) and are cleared on reboot/logout.
