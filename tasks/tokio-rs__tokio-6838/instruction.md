On Unix platforms (notably Linux), Tokio’s Unix domain socket support regressed around v1.40 when using abstract socket addresses.

When a user passes an abstract socket path that begins with a leading NUL byte (e.g. "\0foo") to `tokio::net::UnixListener::bind` and then attempts to connect using `tokio::net::UnixStream::connect` with the same abstract path, the connection can fail even though the same code works on older Tokio versions.

Example:

```rust
use tokio::net::{UnixListener, UnixStream};

#[tokio::main(flavor = "current_thread")]
async fn main() {
    const PATH: &str = "\0foo";
    let _listener = UnixListener::bind(PATH).unwrap();
    assert!(UnixStream::connect(PATH).await.is_ok());
}
```

Additionally, binding an abstract socket with a NUL-prefixed path can result in an incorrect underlying socket name being used (e.g. tools may show the socket as having an extra leading “@”/NUL, like `@@/tmp/...` instead of `@/tmp/...`), indicating the address bytes passed to the OS include an unintended extra zero byte and/or an incorrect length.

Tokio should treat a user-provided abstract address string/byte sequence of the form `"\0" + name` as meaning “abstract socket named `name`” (i.e., exactly one leading NUL denotes abstract namespace). In particular:

- `UnixListener::bind("\0name")` must bind to the abstract socket named `name` (not `\0name`), without introducing an extra leading NUL.
- `UnixStream::connect("\0name")` must successfully connect to a listener bound to the same abstract name.
- This should also work for longer names like `"\0/tmp/mesh/business/mmmeshexample"`.

Currently, passing a NUL-prefixed abstract path causes incorrect handling of the leading NUL when constructing the OS socket address. The implementation needs to ensure the abstract-name constructor is called with the correct “name” bytes (without an extra leading NUL), so that bind/connect use consistent abstract addresses and do not produce doubled prefixes or off-by-one address lengths.