
## 2024-06-19 - [HIGH] Fix insecure temporary file handling
**Vulnerability:** The clipboard sharing functionality created a temporary file (`/tmp/omanix-share-XXXXXX.txt`) to send via `localsend_app`. The script ran `systemd-run` to execute `localsend_app` asynchronously, which caused the script to exit immediately and leave the temporary file with potentially sensitive clipboard contents permanently on disk.
**Learning:** Temporary files created and passed to asynchronous background processes (like `systemd-run`) cannot be cleaned up using regular script `EXIT` traps or sequential `rm` commands, as the script exits before the background task completes.
**Prevention:** 1. Prefer using `${XDG_RUNTIME_DIR:-/tmp}` for temporary files to use a tmpfs (in-memory) filesystem. 2. When passing a temporary file to an asynchronous command, wrap the background command execution in a shell (e.g., `sh -c 'command "$1"; rm -f "$1"' _ "$FILE"`) to ensure cleanup occurs after the task completes.
