
## 2024-06-06 - Temporary File Leaks in Asynchronous Bash Commands
**Vulnerability:** Sensitive data (like clipboard contents) written to temporary files was left on disk because the bash script exited before an asynchronously spawned command (`systemd-run`) finished using the file. Hardcoding `/tmp` also meant data might hit disk instead of a tmpfs.
**Learning:** Bash `trap EXIT` handlers trigger when the *script* exits, not when background children finish. Passing a temp file to a background process guarantees a leak if the script cleans it up on exit (breaking the background process) or leaves it (leaking data).
**Prevention:** 1) Always use `${XDG_RUNTIME_DIR:-/tmp}` for temporary files to ensure they are written to a tmpfs (memory) rather than persistent storage. 2) When passing a temp file to an asynchronous command, wrap it in a shell invocation that deletes the file after the command finishes, e.g., `sh -c 'command "$1"; rm -f "$1"' _ "$TMP"`.
