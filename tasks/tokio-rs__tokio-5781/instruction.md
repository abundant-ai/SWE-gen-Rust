Tokio currently cannot reliably await “error queue” activity on Unix file descriptors (notably UDP sockets using `libc::MSG_ERRQUEUE` on Linux). Users want to use `tokio::io::unix::AsyncFd` to wait until error-queue messages are available, but there is no `Ready` flag that represents error readiness and no way to observe it from `AsyncFdReadyGuard::ready()`.

Implement support for error readiness by introducing `Ready::ERROR` and ensuring it can be observed through `AsyncFd` readiness APIs.

When awaiting readiness with `AsyncFd::ready(...)` (and related methods that produce an `AsyncFdReadyGuard`), the returned guard’s `ready()` set must include `Ready::ERROR` whenever the underlying OS has error readiness available on that FD. This must work even if the user did not request an explicit error interest. On common OS pollers, error readiness is reported regardless of the registered interest mask; Tokio should reflect that behavior so users can successfully wait for error-queue activity without needing an “error interest” to be registered.

The public API should allow code like the following to work as expected:

```rust
let socket: tokio::io::unix::AsyncFd<std::net::UdpSocket> = /* ... */;

loop {
    let mut guard = socket.ready(tokio::io::Interest::READABLE).await?;

    if guard.ready().is_error() {
        match read_from_error_queue(socket.get_ref()) {
            Ok(msg) => {
                // process error-queue message
            }
            Err(ref e) if e.kind() == std::io::ErrorKind::WouldBlock => {
                // no more error-queue messages right now; clear only error readiness
                guard.clear_ready_exact(tokio::io::Ready::ERROR);
                continue;
            }
            Err(e) => return Err(e),
        }
    }
}
```

Requirements:
- Add `Ready::ERROR` and an `is_error()` predicate consistent with existing `Ready` helpers.
- Ensure `AsyncFdReadyGuard::ready()` can report `Ready::ERROR` when the reactor/poller indicates an error event.
- Error readiness must be surfaced regardless of the `Interest` passed to `AsyncFd::ready(...)` (i.e., do not require an `Interest::ERROR` to be registered, since the OS reports error events independently of the interest mask).
- Clearing readiness via `clear_ready_exact(Ready::ERROR)` must allow the task to await the next error readiness transition without spuriously staying ready forever.

This should enable awaiting Linux UDP error-queue notifications (e.g., ICMP errors when `IP_RECVERR` is enabled, and timestamping messages delivered via `MSG_ERRQUEUE`) without interfering with normal readable/writable readiness.