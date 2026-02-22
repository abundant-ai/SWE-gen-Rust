Proxy support in reqwest is currently incomplete/regressed while attempting to move proxy management out of reqwest (as discussed in extracting proxy handling and supporting proxy authentication). In particular, configuring an HTTP proxy with authorization should correctly route requests through the proxy and send the expected `Authorization` header to the proxy.

When a user constructs a proxy using `reqwest::Proxy::http("http://<proxy-host>:<port>")` and attaches it to a client via `reqwest::Client::builder().proxy(proxy).build()`, requests made with that client should be sent to the proxy as an absolute-form HTTP request line (for example `GET http://hyper.rs/prox HTTP/1.1`) with the correct `Host` header (`hyper.rs`) and standard reqwest headers.

Additionally, reqwest must support setting proxy authorization on a `Proxy` via `Proxy::set_authorization(...)` using header values such as `reqwest::header::Bearer { token: "..." }`. When proxy authorization is set, the outgoing proxied request must include an `Authorization: Bearer <token>` header (and it must be sent to the proxy as part of the proxy request).

Currently, with the proxy handling refactor, at least one of these behaviors is broken: either the request is not properly formatted/routed through the proxy, or the proxy authorization header is not being attached to the proxy request. This causes proxy requests to fail (or the proxy to receive a request missing the expected `Authorization` header).

Fix reqwest’s proxy integration so that:

- `reqwest::Proxy::http(...)` produces a proxy configuration usable by the client.
- `Proxy::set_authorization(...)` results in the correct `Authorization` header being sent on requests that go through that proxy.
- A basic proxied GET like `client.get("http://hyper.rs/prox").send()` succeeds and the resulting response URL remains the original target URL (`http://hyper.rs/prox`) with an HTTP 200 OK response when the proxy responds successfully.

This should work without requiring users to depend on hyper-specific header types beyond what reqwest already exposes in `reqwest::header`.