Tokio currently provides `tokio::io::Interest` values like readable/writable, and `tokio::io::unix::AsyncFd` can be awaited for readiness based on those interests. On Linux (and Android), some file descriptors can produce priority/exceptional readiness events (`POLLPRI`), such as `/proc/self/mounts` when mount points change, or sockets receiving data in their error queue. At the moment, there is no way in Tokio to express or await this kind of readiness, so users cannot write `AsyncFd` code that reacts to `POLLPRI` without falling back to custom polling loops.

Implement support for priority readiness in Tokio by exposing a public `Interest::PRIORITY` value and ensuring it is honored by `tokio::io::unix::AsyncFd` readiness APIs.

Expected behavior:
- Users can construct an interest that includes priority events via `tokio::io::Interest::PRIORITY` (and combine it with other interests as supported by the API).
- `tokio::io::unix::AsyncFd` provides convenience methods `priority()` and `priority_mut()` that behave analogously to existing readiness convenience methods (e.g., returning an `AsyncFdReadyGuard` and only completing when the wrapped FD has a priority event ready).
- Waiting for readiness using `AsyncFd` with priority interest should register the correct OS-level readiness so that a `POLLPRI` event wakes the task.

Actual behavior (current):
- There is no `Interest::PRIORITY` in Tokio’s public API, and `AsyncFd` has no `priority()` / `priority_mut()` methods.
- As a result, code cannot compile if it attempts to use `Interest::PRIORITY` or call `AsyncFd::priority()` / `AsyncFd::priority_mut()`, and there is no supported way to await `POLLPRI` readiness events through Tokio.

The implementation should ensure that on platforms where priority readiness is supported by the underlying IO layer (Linux/Android), registering interest in priority events works end-to-end, and the new `AsyncFd` methods integrate with the existing readiness/guard workflow (including clearing readiness via the guard so subsequent priority events can be observed).