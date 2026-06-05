## 2024-06-05 - Insecure Temporary File Handling with Background Processes

**Vulnerability:** Shell scripts using `mktemp` to create temporary files containing sensitive data (like clipboard contents) and passing them to background or asynchronous processes (like `systemd-run` or `ghostty`) had two issues:
1. They wrote to disk (`/tmp`) instead of memory (`$XDG_RUNTIME_DIR`).
2. They used string interpolation (e.g., `sh -c "glow '$FILE'"`) which could lead to command injection, and did not reliably clean up the files because the spawning shell might exit before the asynchronous process finished reading the file.

**Learning:** When passing temporary files to asynchronous or GUI wrappers (like `ghostty -e`), you cannot rely on `trap ... EXIT` in the parent script because the parent script may exit immediately. Additionally, writing sensitive data to `/tmp` on systems where it is not a tmpfs exposes data to disk persistence and potential reading by other users if permissions are lax.

**Prevention:**
1. Always prefer `${XDG_RUNTIME_DIR:-/tmp}` for temporary files to increase the likelihood they are memory-backed (tmpfs) and tied to the user's session.
2. For asynchronous executions that need to consume and delete a file, wrap the execution in a shell invocation that deletes the file *after* consumption: `systemd-run ... sh -c 'command "$1"; rm -f "$1"' _ "$TMP"`.
3. Never interpolate filenames into `sh -c` strings. Always pass them as arguments (`"$1"`) to prevent command injection from maliciously crafted temporary file names (even though `mktemp` usually generates safe names, it's a defensive programming best practice).
