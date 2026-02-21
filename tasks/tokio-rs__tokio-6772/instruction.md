On Linux/Android, connecting to Unix domain sockets using an abstract address regressed after the mio v1 upgrade and Tokio 1.40. Calling `tokio::net::UnixStream::connect` with an abstract socket name (a path beginning with a NUL byte) should work, but it currently fails with an invalid-input error about interior NUL bytes.

For example, this should successfully connect:

```rust
use tokio::net::UnixStream;

#[tokio::main]
async fn main() {
    UnixStream::connect("\0aaa").await.unwrap();
}
```

Actual behavior: `UnixStream::connect("\0aaa")` returns an error like:

```
Error { kind: InvalidInput, message: "paths must not contain interior null bytes" }
```

Expected behavior: paths that start with a leading `\0` must be treated as abstract socket names and should be passed through to the OS connection logic without being rejected for containing NULs.

Additionally, `tokio::net::UnixListener::bind` should correctly handle abstract names without accidentally producing an address with two leading NUL bytes. In particular, when binding with a string that begins with `\0`, the resulting socket address used internally and exposed via `local_addr()` should represent exactly one leading NUL (the abstract namespace indicator) followed by the provided name bytes, not `"\0\0..."`.

After the fix, these scenarios must work:

1) `UnixListener::bind("\0foo")` succeeds and `UnixStream::connect("\0foo").await` can connect.

2) `UnixListener::bind("")` (requesting an unnamed/auto abstract address on platforms that support it) yields a `local_addr()` that can be used to connect by reconstructing the abstract path with a single leading `\0` and the returned abstract name bytes.

The behavior should match `std`’s abstract-socket conventions on Unix: treat a leading NUL as selecting the abstract namespace and avoid any validation that forbids NUL bytes in that specific case.