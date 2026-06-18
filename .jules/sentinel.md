
## 2026-06-18 - Prevent Information Leak in Background Job Temp Files
**Vulnerability:** The `omanix-cmd-share.sh` script saved clipboard contents to a temporary file in `/tmp` and passed it to a background process via `systemd-run`. The temporary file was never deleted after the asynchronous operation finished, meaning any sensitive data copied to the clipboard remained permanently on disk in a predictable directory.
**Learning:** When passing temporary files containing sensitive user data to asynchronous background jobs (like `systemd-run`), traditional shell `trap` cleanup mechanisms execute immediately when the main script exits, which either deletes the file before the background job can read it, or is omitted entirely leaving the file on disk. Furthermore, `/tmp` is not guaranteed to be an in-memory filesystem on all NixOS installations.
**Prevention:**
1. Always prefer `${XDG_RUNTIME_DIR:-/tmp}` for creating temporary files, as it defaults to a user-specific tmpfs (in-memory) mount, preventing secrets from persisting across reboots or being written to physical disks.
2. For asynchronous background jobs, wrap the target command in a shell execution that explicitly deletes the file after the job completes (e.g., `systemd-run sh -c 'command "$1"; rm -f "$1"' _ "$FILE"`).
