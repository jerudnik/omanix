## 2025-02-23 - Async Background Process Data Leakage
**Vulnerability:** Scripts were creating temporary files containing sensitive data (e.g., clipboard contents) in `/tmp/` and passing them to asynchronous background processes (`systemd-run`) without cleaning them up afterwards.
**Learning:** Shell traps like `EXIT` will clean up files when the parent script exits, which happens prematurely if the file is passed to an asynchronous command.
**Prevention:** Always wrap asynchronous commands in a shell execution that explicitly deletes the temporary file after the command finishes, and utilize `${XDG_RUNTIME_DIR:-/tmp}` to keep temporary files out of physical storage.
