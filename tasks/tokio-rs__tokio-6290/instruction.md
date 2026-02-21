Tokio’s Unix domain socket API currently only allows creating a connected stream via `UnixStream::connect`, which prevents users from binding the client side of a Unix stream to a specific filesystem path. This makes it impossible for a server to reliably use `UnixStream::peer_addr()` to retrieve a meaningful pathname for the connecting peer.

Add a new public type `tokio::net::UnixSocket` that represents an unconnected/configurable Unix socket and can be converted into `UnixListener`, `UnixStream`, or `UnixDatagram` after configuration. It must support at least binding to a specific path before use.

Required behavior:

- Construction:
  - `UnixSocket::new_stream() -> io::Result<UnixSocket>` creates a stream (SOCK_STREAM) Unix socket.
  - `UnixSocket::new_datagram() -> io::Result<UnixSocket>` creates a datagram (SOCK_DGRAM) Unix socket.

- Configuration:
  - `UnixSocket::bind<P: AsRef<Path>>(&self, path: P) -> io::Result<()>` binds the socket to the provided pathname.

- Conversions / operations (must enforce correct socket kind):
  - For stream sockets:
    - `UnixSocket::listen(&self, backlog: u32) -> io::Result<tokio::net::UnixListener>` transitions a bound stream socket into a listener.
    - `UnixSocket::connect<P: AsRef<Path>>(&self, path: P) -> impl Future<Output = io::Result<tokio::net::UnixStream>>` connects the (optionally pre-bound) stream socket to a server path.
    - When a client stream socket is bound to a pathname before connecting, the accepted server-side stream’s `peer_addr()?.as_pathname()` must return that bound peer pathname.

  - For datagram sockets:
    - `UnixSocket::datagram(&self) -> io::Result<tokio::net::UnixDatagram>` transitions the socket into a Tokio datagram.

- API misuse errors (exact messages required):
  - Calling `connect(...)` on a datagram `UnixSocket` must return an `io::Error` whose `to_string()` is exactly: `"connect cannot be called on a datagram socket"`.
  - Calling `listen(...)` on a datagram `UnixSocket` must return an `io::Error` whose `to_string()` is exactly: `"listen cannot be called on a datagram socket"`.
  - Similar kind-mismatch checks must exist for the opposite direction as well (e.g., attempting datagram-only operations on a stream socket) with clear, deterministic error strings.

Functional scenarios that must work:

1) Datagram echo with explicit bind
- Create a datagram server with `UnixSocket::new_datagram()`, bind it to `server.sock`, convert via `.datagram()`, then `recv_from` and `send_to` back to the peer’s pathname.
- Create a datagram client with `UnixSocket::new_datagram()`, bind it to `client.sock`, convert via `.datagram()`, `connect(server.sock)`, send bytes, and receive the same bytes back.

2) Stream client bind affects `peer_addr`
- Create a stream listener via `UnixSocket::new_stream()`, bind it to `connect.sock`, and call `.listen(1024)`.
- Create a stream client via `UnixSocket::new_stream()`, bind it to `peer.sock`, and connect to `connect.sock`.
- After accept, the server-side stream’s `peer_addr()?.as_pathname()` must be `Some(peer.sock)`.
- Basic I/O on the stream must work (writing from client, reading to EOF on server).

The new `UnixSocket` type must be exposed under `tokio::net` and be usable under the same platform/feature constraints as existing Unix-domain networking (Unix-only).