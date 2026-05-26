
## 2026-05-26 - Fix command injection in tmux shell functions
**Vulnerability:** Command injection via unsanitized directory paths in tmux bindings.
**Learning:** Shell functions dynamically building tmux send-keys commands were using unsafe single-quote wrapping for paths.
**Prevention:** Use `printf "%q"` to properly escape variables when constructing shell commands as strings.
