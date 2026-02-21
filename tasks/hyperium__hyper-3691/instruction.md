When using the hyper client, requests can fail with `hyper::Error(Canceled, "connection closed")` or `hyper::Error(Canceled, "connection was not ready")` during races where the server closes the connection at the same time the client attempts to send a request. In these cases, the request may not have been written to the wire yet (the connection is noticed as closed before the request is serialized). The request is therefore safe to retry on a different connection, but hyper currently provides no way to recover the original `Request` value once `send_request(req)` is called.

This shows up in higher-level clients (such as those using connection pooling) as non-deterministic `SendRequest` failures even when retry-on-canceled is enabled, because the pool/client cannot retry without regaining ownership of the request.

Add a new async API `SendRequest::try_send_request(request)` for both HTTP/1 and HTTP/2 send handles. This method must behave like `send_request`, but if an error happens after the request has been queued for sending yet before it has actually been written/sent, it must return an error that includes the original request so the caller can retry it.

The method should return `Result<(), TrySendError<B>>` (generic over the request body type) where `TrySendError` distinguishes at least these cases:

- `TrySendError::Queued { error: hyper::Error, request: Request<B> }`: the request was not sent and is returned to the caller. This should be used for the “safe to retry” window (for example, connection hup/closed detected before serialization/write).
- `TrySendError::Sent { error: hyper::Error }`: the request may have been partially or fully sent, so the request cannot be returned.

Expected behavior:

- Calling `try_send_request(req).await` on a connection that gets closed at the wrong time should allow the caller to recover `req` via the `Queued` variant when the request was not written, enabling retry on a new connection.
- If the request has progressed past the point where it might have been written, `try_send_request` must not return the request back; it should instead return the `Sent` variant.
- The existing `send_request(req)` API remains available and keeps its current signature/behavior (it may still return a canceled error without returning the request).

The error values returned in `TrySendError` should preserve the underlying `hyper::Error` such that callers can still inspect it (e.g., as `Canceled` / connection closed).