`tokio::io::unix::AsyncFd` currently has a usability bug in its constructor: if `AsyncFd::new(inner)` fails, the provided `inner` value is dropped and there is no way for the caller to recover it. This prevents error handling patterns that need to inspect or reuse `inner` (for example, to read configuration/state from the object, log details, or retry setup) without forcing callers to clone the inner value before calling `AsyncFd::new`.

Add fallible constructors that never drop the `inner` on failure and instead return it back to the caller together with the underlying `io::Error`.

Implement these APIs on `AsyncFd`:

```rust
impl<T: std::os::unix::io::AsRawFd> AsyncFd<T> {
    pub fn try_new(inner: T) -> Result<Self, (std::io::Error, T)>;

    pub fn try_with_interest(
        inner: T,
        interest: tokio::io::Interest,
    ) -> Result<Self, (std::io::Error, T)>;
}
```

Behavior requirements:
- On success, `try_new` and `try_with_interest` behave like the existing constructors and return `Ok(AsyncFd<T>)`.
- On failure (any error that would previously make construction fail), they must return `Err((io_error, inner))` where `io_error` is the same underlying `std::io::Error` and `inner` is exactly the original value passed in. `inner` must not be dropped when construction fails.
- `try_new(inner)` should use the same default interest configuration as `AsyncFd::new(inner)`.
- `try_with_interest(inner, interest)` should behave like `AsyncFd::with_interest(inner, interest)` but return the inner back on error.

The existing constructors (`AsyncFd::new` / `AsyncFd::with_interest`) may keep their current signatures, but the new `try_*` APIs must be added and must make it possible for callers to handle errors without cloning `inner`.

Example of expected usage:

```rust
let fd = MyFd::open()?;
match tokio::io::unix::AsyncFd::try_new(fd) {
    Ok(async_fd) => { /* use async_fd */ }
    Err((e, fd)) => {
        // fd is still available here for inspection / cleanup / retry
        return Err(e);
    }
}
```
