HTTP/1 responses in the wild sometimes include non-canonical reason phrases (the text after the status code on the status line). hyper currently normalizes reason phrases to the canonical phrase for the status code when emitting responses, and it does not preserve an incoming non-canonical reason phrase when parsing a response.

Add support for preserving and re-emitting non-canonical HTTP/1 reason phrases behind a new feature flag named `http1_reason_phrase`.

When the `http1_reason_phrase` feature is enabled, introduce a new extension type `hyper::ext::ReasonPhrase` that can be stored in a `http::Response`’s extensions. When parsing an HTTP/1 response from the wire, if the reason phrase differs from the canonical reason phrase for the parsed `StatusCode`, store the exact received bytes as `hyper::ext::ReasonPhrase` in the response extensions. If the reason phrase is canonical (or empty/absent in a way that matches canonical behavior), do not store the extension.

When emitting an HTTP/1 response to the wire (server-side encoding), if the response has a `hyper::ext::ReasonPhrase` extension, write that reason phrase on the status line instead of the canonical reason phrase for the status code. If the extension is not present, continue emitting the canonical reason phrase as before.

The reason phrase should be treated as an opaque sequence of bytes for HTTP/1 serialization/parsing purposes (subject only to HTTP/1 line-delimiting rules), so that applications can inspect and manipulate it. The stored reason phrase must round-trip: a response parsed with a non-canonical phrase and then re-encoded should preserve the original phrase exactly when the feature is enabled.

When the `http1_reason_phrase` feature is disabled, behavior must remain unchanged: do not expose `hyper::ext::ReasonPhrase`, do not store non-canonical phrases during parsing, and always emit canonical reason phrases when encoding responses.

Example expected behavior with the feature enabled:
- If a server sends `HTTP/1.1 200 All Good\r\n...`, the parsed `Response` should have status `200 OK`, and `response.extensions().get::<hyper::ext::ReasonPhrase>()` should be present and represent `All Good`.
- If that `Response` is later written back out as an HTTP/1 response, the status line should include `200 All Good`, not `200 OK`.
- If a response is `HTTP/1.1 200 OK\r\n...`, the extension should be absent and re-encoding should continue to emit `OK`.

Ensure this works consistently for both the HTTP client (parsing incoming responses) and the HTTP server (encoding outgoing responses) paths under HTTP/1.