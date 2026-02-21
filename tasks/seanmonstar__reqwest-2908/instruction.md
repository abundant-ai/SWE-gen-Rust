When building requests in WASM, calling `RequestBuilder::json(...)` incorrectly overwrites any previously set `Content-Type` header. This is surprising for users who intentionally set a custom JSON media type (for example `application/vnd.api+json`) and then serialize the body via `.json(payload)`.

Reproduction example:

```rust
use http::{header::CONTENT_TYPE, HeaderValue};
use reqwest::Client;
use std::collections::HashMap;

let mut map = HashMap::new();
map.insert("body", "json");

let content_type = HeaderValue::from_static("application/vnd.api+json");

let req = Client::new()
    .post("https://example.com/")
    .header(CONTENT_TYPE, &content_type)
    .json(&map)
    .build()
    .unwrap();

assert_eq!(content_type, req.headers().get(CONTENT_TYPE).unwrap());
```

Actual behavior (current bug): the request ends up with `Content-Type: application/json` even though the user explicitly set a different value before calling `.json(...)`.

Expected behavior: `RequestBuilder::json(...)` must preserve an existing `Content-Type` header if one is already present on the request. It should only set `Content-Type: application/json` as a default when the header has not been set by the user.

Additionally, when no `Content-Type` has been set manually, calling `.json(payload)` should still result in a request that includes `Content-Type: application/json`.

This should be fixed for the WASM target so that `.json(...)` does not unconditionally clobber `Content-Type` but still applies the default when absent.