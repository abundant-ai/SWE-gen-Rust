Hyper’s client-side name resolution API needs to be updated to use `tower::Service` directly instead of Hyper’s custom `Resolve` trait.

Currently, Hyper exposes a `Resolve` trait for custom DNS/name resolvers used by the client connector. The desired behavior is to remove the `Resolve` trait entirely and make custom resolvers implement `tower::Service<Name>` (where `Name` is the name/authority type Hyper uses for resolution). This should allow resolvers to be composed using Tower utilities (such as `ServiceExt`) and generally interoperate with other Tower middleware.

After this change:

- There must be no `Resolve` trait in the public API. Code that previously accepted a generic `R: Resolve` must instead accept a `tower::Service<Name>`.
- The resolver service must be polled for readiness (via `poll_ready`) and then called (via `call(Name)`) to produce the resolution result. The response must represent resolved socket addresses usable by the HTTP connector.
- The client connector that performs DNS/name resolution must be updated accordingly so that custom resolver services are actually used during connection establishment.

In addition, the error type surfaced by the HTTP connector must change:

- The error type of `HttpConnector` must no longer be `std::io::Error`. Instead, it should use an error type that can represent both I/O connection failures and resolution/service-related failures (for example, failures returned by the resolver `Service`).
- When resolution fails (e.g., the resolver service returns an error), that error must be propagated through the connector/client as the connector error type (not coerced into `std::io::Error`).

Expected behavior for users:

- A user can provide a custom resolver by implementing `tower::Service<Name>`.
- Requests made with `hyper::Client` using an `HttpConnector` configured with that resolver will perform resolution through the provided service.
- Connection failures and resolution failures propagate with the updated `HttpConnector` error type.

This is a breaking change: any examples or public APIs that previously referenced `Resolve` should be updated so that downstream code only needs to implement `tower::Service<Name>` for custom resolution.