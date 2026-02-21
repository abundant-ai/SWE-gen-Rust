`tower_buffer::Buffer` is intended to behave like an ordinary `tower_service::Service`, returning a response future that can be polled to completion and correctly handling backpressure, cancellation, and inner-service failures. After updating the ecosystem to rely on `std::future::Future` and a newer `pin-project` projection signature, the buffer’s response futures and internal task state must still be safely pinnable and pollable without requiring callers to use nonstandard future traits.

When a user calls `Buffer::call(req)`, the returned value must implement `std::future::Future` and, when pinned, must successfully drive the buffered request to completion.

The following behaviors must work:

- Basic request/response: calling the buffered service with a request like `"hello"` should eventually resolve the returned future to the inner service’s response (e.g. `"world"`) once the inner service is allowed to process and a response is sent.

- Cancellation cleanup: if a request is queued behind backpressure and its response future is dropped before the inner service handles it, the buffer must cancel that queued request so it does not consume capacity later. Concretely, if three requests are made while only one is allowed through, and the second request’s future is dropped, then after the first response completes and capacity is restored, the third request must be the next one delivered to the inner service (the canceled second request must not block or be delivered).

- Inner not-ready/backpressure: if the inner service is temporarily not ready (no capacity), polling the response future should return `Poll::Pending` until the buffer’s executor/background worker can make progress and the inner service becomes available. Once capacity is granted and the inner responds, the response future must become ready with the correct value.

- Inner failure propagation: if the inner service fails while handling a request, the response future must resolve to an error. The error must preserve the inner error as the source, so that callers can downcast to `tower_buffer::error::ServiceError` and then read `source()` to get the original inner error message (e.g. a source error whose `to_string()` is `"foobar"`).

Additionally, the code must compile against the updated `pin-project` behavior where the generated projection method has the signature `fn project(self: Pin<&mut Self>) -> ProjectedType;` (rather than taking `&mut Pin<&mut Self>`). Any internal pinned types used by the buffer’s futures/tasks must be updated accordingly so they can be projected and polled safely.

Overall expected result: `tower_buffer::Buffer` continues to provide a `std::future::Future`-based response type that is pin-safe, works with common executors and `Pin::as_mut`, and preserves the above buffering/cancellation/error semantics.