Reqwest’s HTTP/3 client connection establishment has two related concurrency/synchronization bugs that make HTTP/3 unreliable under failure and concurrent load.

1) Stuck “connecting already in progress” after a failed attempt
When an initial HTTP/3 connection attempt to an origin fails (for example, dialing an address/port where nothing is listening and the attempt times out), subsequent requests to that same origin using the same `reqwest::Client` should be able to attempt a new connection. Instead, after the first failure, later requests fail immediately with an error like `HTTP/3 connecting already in progress`, as if a connection attempt were still ongoing. This indicates the internal “connecting” lock/state is not being released/reset when the connection attempt returns an error.

Reproduction scenario:
- Build a `reqwest::Client` configured for HTTP/3 prior knowledge (and accepting invalid certs for local testing).
- Send an HTTP/3 request to `https://[::1]:<unused_port>/` and wait for it to fail with a QUIC connection timeout.
- Send the same request again.

Expected behavior:
- Both requests should fail due to the underlying QUIC timeout (e.g., `quinn::ConnectionError::TimedOut`), not due to a client-side “connecting already in progress” state.
- After those failures, if a valid HTTP/3 server is started on that same address/port, a subsequent request using the same client should successfully establish a new HTTP/3 connection and complete.

Actual behavior:
- After the first failed connection attempt, subsequent attempts are blocked and fail with `HTTP/3 connecting already in progress`.

2) Concurrent requests should wait for an in-progress connection instead of failing
If multiple tasks concurrently send HTTP/3 requests through the same `reqwest::Client` to the same origin while no HTTP/3 connection exists yet, only one task should perform the connection establishment and the others should wait for the result.

Expected behavior:
- When one task begins establishing the HTTP/3 connection, other concurrent tasks should not immediately error.
- They should await until the connection either becomes ready (then proceed to send their requests) or fails (then receive the same underlying connection error).
- When establishment succeeds, all waiting tasks should be notified and allowed to use the newly established connection.

Actual behavior:
- Concurrent callers immediately receive `HTTP/3 connecting already in progress` instead of waiting.

What needs to be implemented/fixed:
- Ensure that the internal “HTTP/3 connecting” guard/state is always cleared when a connection attempt finishes, including when it errors or is dropped early, so subsequent attempts are not permanently blocked.
- Add proper synchronization around HTTP/3 connection establishment so that only one connection attempt is in-flight per origin, while other concurrent requests subscribe/wait for its completion and then proceed using the same established connection.
- Preserve the underlying QUIC connection error as the surfaced failure in these scenarios (e.g., a timeout should still be observable as `quinn::ConnectionError::TimedOut` via error sources), rather than replacing it with `HTTP/3 connecting already in progress`.

The public-facing API involved includes constructing a `reqwest::Client` with HTTP/3 enabled (e.g., via `Client::builder().http3_prior_knowledge()...build()`), and making requests that explicitly use HTTP/3 (e.g., `RequestBuilder::version(http::Version::HTTP_3)` followed by `.send().await`).