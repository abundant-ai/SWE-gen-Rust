HTTP/1 connections are not being reused reliably when a response body is not fully consumed and is dropped early, especially when the body is wrapped/decoded (for example with gzip). This can cause clients to open new TCP connections unnecessarily and, on servers/frameworks that expect unread request/response data to be handled gracefully, can lead to aborted connections or errors while trying to write a response.

In the client case, performing a request and then calling a helper like `response.text().await` (or otherwise dropping the `Body` without explicitly draining it) should still allow the underlying HTTP/1 connection to be returned to the pool and reused when it is safe to do so. Currently, when the user drops the `Body` before it has been fully read, hyper may leave unread bytes in the connection’s read buffer and fail to transition the connection back to an idle/keep-alive state, preventing reuse. This shows up as repeated `connecting to ...` behavior instead of reusing an existing connection.

In the server-side style failure, leaving data unread should not forcefully break the connection in a way that prevents writing a response. Users can see logs like “Data left unread. Force closing network stream.” followed by a write failure such as `Os { kind: ConnectionAborted, message: "An established connection was aborted by the software in your host machine." }`. Hyper should try to handle the situation by draining what’s already buffered/available (when possible) so that the connection state is consistent and a response can still be written (or, for clients, so keep-alive reuse remains possible).

Fix the HTTP/1 connection handling so that when a `Body` is dropped by the user, hyper attempts to drain any remaining readable bytes already buffered for that message (without requiring the user to explicitly read to EOF) and correctly updates the connection state machine so that:

- For the client, the connection can be returned to the pool and reused when the response is otherwise complete and the peer allows keep-alive.
- Dropping a response `Body` does not leave the connection in a permanently “busy” or non-reusable state solely due to buffered unread bytes.
- The behavior is consistent whether the body is plain or wrapped by decoders (e.g., gzip), so enabling gzip does not prevent connection reuse.

A concrete scenario that should work:

1) Make an HTTP/1 request with `Client` and receive a `Response<Body>`.
2) Partially read or do not read the `Body` and then drop it.
3) Make a subsequent request to the same origin.

Expected: the second request reuses the existing keep-alive connection when the server supports it.

Actual (current): the second request often creates a new connection because the prior one was not properly drained/marked idle after `Body` was dropped.