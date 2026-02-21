Creating a rustls server configuration currently makes it unnecessarily difficult to use a built-in implementation of `ResolvesServerCert` that serves a single certificate chain and private key.

There is an internal implementation, `SingleCertAndKey`, that already implements `rustls::server::ResolvesServerCert`, but it is not exported. Downstream users who want a simple resolver must either reimplement the resolver themselves or rely on non-public/internal items.

In addition, downstream code that wants to build a `CertifiedKey` from DER-encoded certificate/key material lacks a public constructor that performs the same validation checks as rustls expects. Users need a public API to create a `CertifiedKey` from DER input with the necessary correctness checks applied.

Update the public API so that:

- `SingleCertAndKey` is publicly exported as an implementation of `rustls::server::ResolvesServerCert`, so users can construct a resolver for a server that always presents the same certified key.
- `CertifiedKey::from_der()` is publicly exposed and can be used to create a `CertifiedKey` from DER-encoded certificate chain and private key material, performing the required validation so invalid combinations are rejected (for example, mismatched certificate/private key, or unsupported key types).

After these changes, downstream crates should be able to:

- Use `SingleCertAndKey` directly when configuring a server that does not need SNI-based or dynamic certificate selection.
- Use `CertifiedKey::from_der()` to build a `CertifiedKey` without reaching into internal modules, and rely on it to enforce rustls’ expected invariants (returning an error when inputs are invalid rather than allowing construction of a broken `CertifiedKey`).