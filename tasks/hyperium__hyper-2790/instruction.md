Hyper’s HTTP/1 client connection can panic with the message "dispatch dropped without returning error" when the background dispatch is dropped while there are still in-flight requests waiting for a response.

This is reproducible when using `hyper::client::conn::http1::handshake(...)` to obtain a `request_sender` and a `connection`, starting a request with `request_sender.send_request(request)`, and then dropping the `connection` before the response future is polled to completion. In that situation, polling the response future can currently panic instead of yielding an error.

Example:

```rust
let (mut request_sender, mut connection) = hyper::client::conn::http1::handshake(io).await?;
let req = hyper::Request::builder().body("".to_string())?;
let fut = request_sender.send_request(req);

futures_util::pin_mut!(fut);
let _ = futures_util::poll!(&mut connection);
drop(connection);

// Should return Err(...), but currently can panic.
let _ = futures_util::poll!(&mut fut);
```

Expected behavior: when the dispatch/connection goes away unexpectedly (for example because the runtime is dropped, the connection future is dropped, or user code causes the dispatch task to terminate), any pending `send_request` response future must resolve to an `Err(hyper::Error)` indicating the connection/dispatch was closed, rather than panicking.

Actual behavior: under certain timing, the dispatch drops without sending a final error back to the waiting response future, leading to a panic with "dispatch dropped without returning error".

Fix the client HTTP/1 dispatch/callback handling so that dropping the dispatch/client state cannot leave an in-flight request without a completion signal. If the dispatch is dropped while a callback/sender is held, ensure the waiting side receives a proper error value (and the response future becomes ready with `Err`) instead of triggering the panic.