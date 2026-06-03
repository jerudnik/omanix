
## 2024-06-03 - [File Leak]
**Vulnerability:** Temporary file containing sensitive clipboard content not deleted after asynchronous systemd-run execution.
**Learning:** Background processes executed via `systemd-run` outlive the bash script, causing `EXIT` traps or sequential `rm` commands to fail or execute prematurely.
**Prevention:** Wrap asynchronous execution in a subshell or shell execution with proper cleanup (e.g., `bash -c 'cmd; rm -f "$1"' _ "$TMP"`). Use `XDG_RUNTIME_DIR` for sensitive temporary data.
