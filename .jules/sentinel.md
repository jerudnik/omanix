## 2024-05-27 - Insecure Temporary File / Data Leak in clipboard sharing
**Vulnerability:** A script writing potentially sensitive clipboard data to a temporary file in `/tmp` without secure cleanup when using `systemd-run`.
**Learning:** `mktemp` in `/tmp` writes to physical disk, and when passing files to `systemd-run` without `--wait`, the script exits, leaving the uncleaned temp file behind.
**Prevention:** Always use `${XDG_RUNTIME_DIR:-/tmp}` for tmpfs, add `trap 'rm -f $TMP' EXIT`, and ensure asynchronous commands process the file by using `--wait` before exiting.
