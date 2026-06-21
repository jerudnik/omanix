## 2024-06-21 - Command Injection in Script Execution
**Vulnerability:** The `omanix-launch-or-focus.sh` script used `eval exec setsid "$LAUNCH_COMMAND"` combined with a flattened argument string (`"omanix-launch-tui $*"`) in the calling script. This allowed command injection if an app ID or argument contained shell metacharacters like `;`.
**Learning:** Shell scripts launching nested commands or GUI apps should never use `eval` or `$*` string flattening when handling user or application-provided arguments, as it treats strings as executable code rather than passing arguments strictly via `execve`.
**Prevention:** Always pass variable arguments safely using arrays (`"$@"`) and avoid using `eval` for command construction to prevent arbitrary shell interpretation.
