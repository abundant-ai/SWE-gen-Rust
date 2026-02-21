The public API surface of rustls is currently inconsistent with how parts of the library need to be tested and consumed: several handshake/message-layer types are effectively being accessed through `rustls::internals`, and this creates two problems.

First, the crate should not require external code (including non-integration unit-style usage) to reference `rustls::internals::*` in order to construct, inspect, or validate handshake-related structures. In particular, low-level handshake extension types such as `ServerExtension` and `ClientExtension` should be able to become private implementation details without breaking the ability to validate handshake parsing/encoding behavior.

Second, the `CertificateType` enum (used for certificate-related handshake semantics and parsing/encoding) needs to be part of the public API. Right now, consumers who need to refer to certificate type values cannot do so through the stable public surface, and API checks that are meant to detect missing public exports are masked by accidental `rustls::internals::*` usage.

Update rustls so that:

- `CertificateType` is publicly available as `rustls::CertificateType` (so downstream code can name and use this enum type directly).
- Handshake parsing/encoding and validation logic still works correctly after reducing/avoiding exposure of internal handshake extension enums/structs (eg, `ServerExtension` and `ClientExtension` should be free to be private without breaking compilation or required functionality).
- The low-level handshake message code continues to correctly reject malformed encodings (eg truncated fields like Random and SessionId) and correctly read/encode well-formed values, preserving existing error behavior (eg returning an error on insufficient bytes rather than panicking).

A concrete example of the expected behavior is that calling `Random::read(&mut Reader::init(&bytes))` must return an error when `bytes` is 31 bytes long, and succeed when `bytes` is exactly 32 bytes long; similarly, `SessionId::read(...)` must reject truncated inputs and reject invalid length encodings. These behaviors must remain correct while making the internal extension representation types non-public and while exposing `CertificateType` via the public API.