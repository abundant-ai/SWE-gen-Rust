On Unix platforms, `tokio::net::UnixStream` and `tokio::net::UnixListener` have incorrect readiness / EOF behavior around half-close and peer shutdown, which can lead to incorrect reads, missed wakeups, or streams not reporting EOF properly.

When a `UnixListener` accepts a connection and the client writes some bytes and then drops the connection, the server side should be able to:

```rust
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{UnixListener, UnixStream};

# async fn repro(sock_path: std::path::PathBuf) -> std::io::Result<()> {
let listener = UnixListener::bind(&sock_path)?;
let accept = listener.accept();
let connect = UnixStream::connect(&sock_path);
let ((mut server, _addr), mut client) = futures::future::try_join(accept, connect).await?;

client.write_all(b"hello").await?;
drop(client);

let mut buf = vec![];
server.read_to_end(&mut buf).await?;
assert_eq!(&buf, b"hello");

let n = server.read(&mut buf).await?;
assert_eq!(n, 0); // must report EOF after peer closes
# Ok(()) }
```

Currently, after the peer closes, the subsequent `read()` does not reliably return `Ok(0)` (EOF) in all cases, or readiness does not transition correctly, causing hangs or incorrect behavior in code that expects EOF to be observable after draining the stream.

Additionally, calling `AsyncWriteExt::shutdown(&mut client).await` on a `UnixStream` should perform a half-close such that the peer observes EOF on read:

```rust
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{UnixListener, UnixStream};

# async fn repro_shutdown(sock_path: std::path::PathBuf) -> std::io::Result<()> {
let listener = UnixListener::bind(&sock_path)?;
let ((mut server, _), mut client) = futures::future::try_join(listener.accept(), UnixStream::connect(&sock_path)).await?;

AsyncWriteExt::shutdown(&mut client).await?;

let mut b = [0u8; 1];
let n = server.read(&mut b).await?;
assert_eq!(n, 0); // peer should observe EOF after shutdown
# Ok(()) }
```

Right now, `shutdown()` does not consistently result in the peer seeing EOF (read returning `0`), or the readiness state does not wake tasks waiting on readability.

Fix `tokio::net::UnixStream` / `UnixListener` so that:
1) After the peer fully closes, reads on the other side reliably return `Ok(0)` once all pending bytes are read.
2) After `AsyncWriteExt::shutdown()` (half-close), the peer reliably observes EOF (`read` returns `0`).
3) Readiness notifications (`readable()` / `writable()` with `Interest`) correctly wake waiting tasks when the stream becomes readable due to incoming data or due to EOF/hangup, and `try_read` / `try_write` semantics remain consistent (return `WouldBlock` only when appropriate).

The end result should be that applications using `read_to_end`, `read`, `shutdown`, `readable()`, `writable()`, `try_read`, and `try_write` on `UnixStream` do not hang or miss EOF transitions during peer close or shutdown.