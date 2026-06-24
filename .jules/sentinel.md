## 2024-06-24 - Uncleaned temporary files with sensitive data in asynchronous commands
**Vulnerability:** Clipboard content (which could contain passwords, API keys, or other sensitive information) was saved to `/tmp` and passed to an asynchronous `systemd-run` command without being explicitly deleted afterwards. This left sensitive data exposed on the physical disk for anyone with access to the system.
**Learning:** When creating temporary files with sensitive content that are passed to asynchronous processes, standard `trap` cleanup or synchronous deletion (`rm -f`) does not work. Additionally, `/tmp` is not guaranteed to be an in-memory (`tmpfs`) filesystem on all distributions, so writing secrets to it risks persistence on disk.
**Prevention:**
1.  Always try to use `${XDG_RUNTIME_DIR:-/tmp}` for temporary files, as `XDG_RUNTIME_DIR` is typically backed by `tmpfs` (in-memory) and user-specific.
2.  When passing temporary files to asynchronous commands (like `systemd-run` or background tasks), wrap the execution in a shell block (`sh -c 'command "$1"; rm -f "$1"' _ "$FILE"`) to guarantee cleanup *after* the async process finishes using the file.
