`tokio::net::TcpStream::set_linger` (and the corresponding linger-setting API on Tokio TCP sockets) exposes `SO_LINGER` on the underlying OS socket. On Linux, enabling linger can make `close()`/`shutdown()` block the calling thread until pending data is sent or the linger timeout expires. In Tokio this is particularly problematic because dropping a `TcpStream` or shutting it down can occur on a runtime worker thread, causing that worker thread to block unexpectedly.

The networking API should be updated so that calling `set_linger(...)` on Tokio TCP types is deprecated, because using it can lead to blocking behavior when the stream is dropped or shut down. This should apply to `TcpStream::set_linger(...)` and also the equivalent setter on `tokio::net::TcpSocket`.

The deprecation should be visible to users at compile time (i.e., calling these methods triggers a deprecation warning), but the methods must continue to work for now for compatibility: reading the linger option via `linger()` should continue to be supported and should not be deprecated.

Expected behavior:
- Code that calls `tokio::net::TcpStream::set_linger(...)` produces a deprecation warning.
- Code that calls `tokio::net::TcpSocket::set_linger(...)` produces a deprecation warning.
- `linger()` remains available and is not deprecated.
- Existing behavior of setting and reading linger remains functional (e.g., default linger is `None`, setting linger to `Some(Duration::new(0, 0))` can be observed via `linger()` returning that value).

This change is motivated by the fact that enabling linger can cause a noticeable delay between dropping/shutting down the stream and subsequent code executing, because the drop/shutdown path can block until the OS completes the linger behavior.