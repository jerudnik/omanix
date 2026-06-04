## 2024-05-24 - Sensitive Clipboard Data Leak in Share Script
**Vulnerability:** The clipboard sharing script (`omanix-cmd-share.sh`) saved the user's clipboard contents to a temporary file in `/tmp` and sent it asynchronously via `systemd-run`. Since `systemd-run` runs in the background, there was no cleanup of the temporary file, meaning sensitive data (like copied passwords or private keys) was left permanently accessible in the filesystem until reboot or manual deletion.
**Learning:** Using `systemd-run` without `--wait` creates a detached background process. Standard shell scripts often overlook cleaning up temporary files passed to such asynchronous processes. An `EXIT` trap on the main script is insufficient because the main script exits before the background process finishes using the file.
**Prevention:**
1. Use `${XDG_RUNTIME_DIR:-/tmp}` for temporary files to prefer an in-memory (`tmpfs`) file system over persistent storage.
2. When passing a temporary file to an asynchronous or detached background process, wrap the execution in a short shell script that executes the command and then deletes the file: `sh -c 'command "$1"; rm -f "$1"' _ "$FILE"`.
