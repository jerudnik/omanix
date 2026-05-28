## 2024-05-19 - Hardcoded `/tmp` usages and asynchronous temporary files
**Vulnerability:** Several scripts create temporary files in `/tmp` using `mktemp` without utilizing `$XDG_RUNTIME_DIR`.
**Learning:** Hardcoded `/tmp` usage bypasses the more secure and resilient in-memory `tmpfs` setup commonly provided by `XDG_RUNTIME_DIR` in modern setups. In cases where the file is handed to a background asynchronous process (like systemd-run or ghostty), deleting the file in an EXIT trap within the script will delete it before the process can use it.
**Prevention:** Use `${XDG_RUNTIME_DIR:-/tmp}` for paths. Rely on the asynchronous process to clean up the temporary file instead of an EXIT trap, or use systemd-run --wait if blocking is acceptable.
