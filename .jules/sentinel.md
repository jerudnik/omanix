## 2026-06-16 - Clipboard Data Leak in Share Script
**Vulnerability:** Clipboard content containing potentially sensitive data was saved to a temporary file on disk (/tmp/) without being deleted after it was sent via an asynchronous process (systemd-run).
**Learning:** Temporary files passed to asynchronous background processes (like systemd-run without --wait) will not be cleaned up if the script exits immediately, leading to sensitive data lingering on disk.
**Prevention:** Always use ${XDG_RUNTIME_DIR:-/tmp} for temporary files so they are stored in a tmpfs (RAM), and when passing temp files to asynchronous commands, wrap the execution in a shell (e.g. sh -c 'command "$1"; rm -f "$1"') to guarantee cleanup.
