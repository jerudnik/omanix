
## 2024-06-07 - Secure Cleanup of Temporary Files in Asynchronous Commands
**Vulnerability:** Temporary files containing sensitive data (like clipboard contents) were written to disk (`/tmp`) and left uncleaned when passed to asynchronous background commands like `systemd-run`.
**Learning:** Shell `EXIT` traps or inline `rm` don't reliably clean up files if they are given to background processes that return immediately. The original process exits and deletes the file before the asynchronous command finishes, or in this case, the file was not deleted at all.
**Prevention:** 1. Always write temporary files to tmpfs (`${XDG_RUNTIME_DIR:-/tmp}`) instead of `/tmp`. 2. When passing a temp file to an asynchronous runner (like `systemd-run` or `ghostty`), wrap the command in a shell execution that cleans up the file after the inner command finishes, e.g., `sh -c 'command "$1"; rm -f "$1"' _ "$FILE"`.
