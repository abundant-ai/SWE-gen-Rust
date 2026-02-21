Tokio’s socket option API currently exposes `TcpSocket::tos` and `UdpSocket::tos` for setting/getting the IPv4 Type of Service (TOS) value. This name is misleading because the underlying option is IPv4-specific, and there is no equivalent API for setting the IPv6 Traffic Class (TCLASS) value.

Update the public API so that IPv4 and IPv6 are handled explicitly:

When working with IPv4 sockets, users should be able to call `TcpSocket::tos_v4()` / `TcpSocket::set_tos_v4(u32)` and `UdpSocket::tos_v4()` / `UdpSocket::set_tos_v4(u32)` to read and write the IPv4 TOS field.

When working with IPv6 sockets, users should be able to call `TcpSocket::tclass_v6()` / `TcpSocket::set_tclass_v6(u32)` and `UdpSocket::tclass_v6()` / `UdpSocket::set_tclass_v6(u32)` to read and write the IPv6 Traffic Class field.

The new IPv6 methods must operate on IPv6 sockets created via `TcpSocket::new_v6()` and on `UdpSocket` instances using an IPv6 socket under the hood; calling the IPv6 Traffic Class APIs should correctly round-trip the value (a value set via the setter must be returned by the getter).

The existing `tos` APIs must be renamed to `tos_v4` to reflect that they are IPv4-only. After the change, code using `TcpSocket::tos` / `set_tos` or `UdpSocket::tos` / `set_tos` should no longer be the canonical way to access this option; the IPv4-specific `*_v4` names should be available and used consistently.

Overall expected behavior:
- IPv4: setting TOS through `set_tos_v4` and reading via `tos_v4` works and returns the same value.
- IPv6: setting Traffic Class through `set_tclass_v6` and reading via `tclass_v6` works and returns the same value.
- The TCP and UDP socket option APIs should provide a consistent set of methods across both protocols for these fields.