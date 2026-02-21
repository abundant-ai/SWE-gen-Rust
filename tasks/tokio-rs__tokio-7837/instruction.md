`tokio::net::TcpStream::set_linger(Some(duration))` configures `SO_LINGER` on the underlying socket. On Linux, enabling linger with a nonzero timeout can cause `close()`/`shutdown()` to block until pending data is flushed or the timeout expires. In Tokio, this can unexpectedly block a runtime worker thread when a `TcpStream` is dropped or shut down, leading to stalls in otherwise async code.

Add an API to allow users to opt into the common “abortive close” behavior (send RST immediately on close) without needing to call `set_linger(Some(Duration::from_secs(0)))` themselves, and ensure it works consistently across Tokio’s TCP types.

Implement `set_zero_linger()` on Tokio TCP sockets/streams so that calling it sets the linger option to exactly zero seconds (i.e., `linger = Some(Duration::new(0, 0))`). This method must be available on both `tokio::net::TcpStream` and `tokio::net::TcpSocket`.

Expected behavior:

- Calling `set_zero_linger()` on a TCP socket/stream succeeds on supported platforms and results in `linger()` returning `Some(Duration::new(0, 0))`.
- A TCP connection that has `set_zero_linger()` enabled on one side should trigger a TCP reset when that side is dropped/closed. In particular, if a server accepts a connection, calls `set_zero_linger()` on the accepted stream, and then drops it, the peer should still be able to call `AsyncWriteExt::shutdown(&mut stream).await` without the operation hanging or failing unexpectedly.
- Repeated calls to `AsyncWriteExt::shutdown(&mut TcpStream).await` should remain safe/idempotent (multiple shutdown calls should all return `Ok(())`).

The goal is to provide a clear, non-blocking alternative to `set_linger(Some(nonzero))` for users who need deterministic close behavior, and to ensure Tokio’s shutdown logic remains robust even when the peer resets the connection due to zero-linger settings.