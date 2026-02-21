`tokio::task::block_in_place` is currently allowed to run inside `!Send` tasks spawned with `tokio::task::spawn_local` on a `tokio::task::LocalSet`. This is intended to be unsupported, but today it does not reliably fail fast: calling `block_in_place` from within a `spawn_local` task can proceed without panicking. In practice, this can lead to serious runtime issues (e.g., worker threads disappearing/hanging behavior) because `block_in_place` assumes it can hand off work in a way that is incompatible with `LocalSet`’s local-task execution.

Change the runtime behavior so that attempting to block inside `LocalSet` execution is rejected deterministically.

When a `spawn_local` task running on a `LocalSet` calls `tokio::task::block_in_place(|| { ... })`, Tokio must panic (fail fast) rather than allowing the call to proceed. This should also cover cases where the `LocalSet` is being driven either by awaiting the `LocalSet` itself or by using `LocalSet::run_until(...)`.

In other words, blocking must be disallowed while inside `LocalSet`’s internal execution context, including during `LocalSet::poll` and during `LocalSet` shutdown/teardown (`Drop`) if that code path would otherwise permit blocking.

Expected behavior example:

```rust
use tokio::task::{self, LocalSet};

#[tokio::main(flavor = "multi_thread")]
async fn main() {
    let local = LocalSet::new();
    local
        .run_until(async {
            task::spawn_local(async {
                let _ = task::block_in_place(|| 123);
            })
            .await
            .unwrap();
        })
        .await;
}
```

This program must panic at the point `block_in_place` is invoked from the `spawn_local` task.

Currently: the call may not panic and can lead to runtime instability.

After the fix: the call reliably panics whenever `block_in_place` is used from within `LocalSet`-driven local tasks.