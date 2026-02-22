When composing subscribers using `tracing_subscriber::layer::SubscriberExt::with(...)`, the resulting `Layered` subscriber does not propagate the `Subscriber::on_register_dispatch(&Dispatch)` callback to its contained layer(s). As a result, layers that rely on `on_register_dispatch` (including mock layers/subscribers that set expectations on this callback) never see their `on_register_dispatch` method invoked when the layered subscriber is installed as the default dispatcher.

Reproduction:
- Create two layers that implement `on_register_dispatch` (or set an expectation that `on_register_dispatch` is called).
- Build a subscriber via `tracing_subscriber::registry().with(inner_layer).with(outer_layer)`.
- Install it as the default using either `tracing::subscriber::with_default(subscriber, || { ... })` or `tracing_subscriber::util::SubscriberInitExt::set_default()`.

Expected behavior:
- Installing the subscriber as the default must result in `on_register_dispatch` being called for every layer in the `Layered` stack (both the inner and outer layers), and also for any wrapped subscriber that expects this callback.

Actual behavior:
- `on_register_dispatch` is never called on layers inside `Layered`, so expectations for this callback are not satisfied and layer initialization that depends on receiving the `Dispatch` does not occur.

Fix required:
- Ensure `Layered`’s `Subscriber` implementation includes `on_register_dispatch(&Dispatch)` and properly forwards/propagates the callback through the layered subscriber so that all composed layers receive it when the subscriber is registered as the default dispatch.