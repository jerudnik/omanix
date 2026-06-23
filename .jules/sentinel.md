
## 2024-06-25 - Information Disclosure in Clipboard Sharing
**Vulnerability:** Clipboard contents (which may contain passwords or sensitive data) were written directly to `/tmp` and never cleaned up if the `localsend_app` succeeded.
**Learning:** Background processes (`systemd-run` without `--wait`) complicate temporary file cleanup since standard `trap "rm -f $TMP" EXIT` will delete the file before the background process can read it.
**Prevention:** Use `$XDG_RUNTIME_DIR` (tmpfs) to avoid writing to physical disk, and use a wrapper shell command `sh -c 'command "$1"; rm -f "$1"' _ "$TMP"` in the background job to ensure deletion occurs only *after* the job completes.
