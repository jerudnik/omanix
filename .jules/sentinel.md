## 2024-05-29 - Insecure Temporary File Creation
**Vulnerability:** Shell scripts using `mktemp` to create temporary files in `/tmp` for storing sensitive data like clipboard contents.
**Learning:** By default, `/tmp` is often disk-backed. Writing sensitive data here leaves traces on the physical disk.
**Prevention:** Always use `${XDG_RUNTIME_DIR:-/tmp}` for temporary files containing sensitive data to ensure they are written to an in-memory tmpfs partition.
