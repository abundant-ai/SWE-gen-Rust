The crate’s streaming functionality is gated behind a Cargo feature that used to be named `unstable-stream`, but the intended public feature name is now `stream`. As a result, enabling `stream` does not correctly activate the streaming code paths (or the crate still expects `unstable-stream` in some places), and functionality that should be available under `stream` is missing or incorrectly compiled.

When the `stream` feature is enabled, streaming request bodies must be supported through `reqwest::Body::wrap_stream(...)`, and multipart uploads must support streaming parts via `reqwest::multipart::Part::stream(body)`.

Expected behavior with the `stream` feature enabled:
- Code that calls `reqwest::Body::wrap_stream(...)` should compile and work.
- Creating a multipart form with a streaming part (for example, `Form::new().text("foo", "bar").part("part_stream", Part::stream(body))`) should send the request using chunked transfer encoding (no `Content-Length` header required for the full body) and the serialized multipart body should contain the streamed bytes in the correct position within the multipart boundaries.

Actual behavior:
- Enabling the `stream` feature does not reliably enable the streaming APIs/implementations (or compilation fails due to mismatched `cfg(feature = ...)` names), because parts of the crate still reference `unstable-stream` while others reference `stream`.

Update the crate so that `stream` is the single, correct feature flag controlling all streaming functionality, including `Body::wrap_stream` and multipart streaming parts via `multipart::Part::stream`. Any internal conditional compilation and feature wiring should consistently use `stream` so users can enable streaming by specifying `features = ["stream"]` in Cargo.