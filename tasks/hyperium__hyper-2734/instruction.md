HTTP/1 header parsing currently fails to handle “obsolete line folding” (obs-fold), where a header field value may be continued on the next line if the next line starts with SP or HTAB. Some real-world servers/clients still emit such folded headers, and Hyper’s HTTP/1 implementation should accept them by unfolding them into a single header value.

When parsing HTTP/1 messages (both requests and responses), if a header line is immediately followed by one or more continuation lines that begin with a space (SP) or tab (HTAB), those continuation lines must be treated as part of the previous header’s field-value. The parser should combine them into a single header value by replacing each CRLF + (SP/HTAB)+ sequence with a single space, preserving the rest of the bytes in order.

Currently, receiving a response that includes a folded header (for example:

```
HTTP/1.1 200 OK
Foo: hello
 world


```

) does not yield a valid `Foo` header value of `"hello world"`. Instead, Hyper rejects the message or mis-parses headers, which causes the client to fail to read the response successfully.

Update the HTTP/1 header parsing so that folded header values are accepted and unfolded. The behavior should apply consistently to both client-side response parsing and server-side request parsing. After the change, a `Client` receiving a response with folded headers should successfully construct the `Response` with the unfolded header value available via `response.headers().get("Foo")`.

The implementation must also ensure that folding is only treated as a continuation of an existing header line; a leading SP/HTAB line must not be accepted as a new header name. If a continuation appears without a preceding header field to attach to, it should be treated as an invalid message.