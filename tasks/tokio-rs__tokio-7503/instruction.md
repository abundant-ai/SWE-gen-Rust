On Linux with the `process` feature enabled, spawning a child process via `tokio::process::Command` and then interrupting it can hang or fail to complete reliably when done concurrently.

A concrete reproduction is to repeatedly do the following in many concurrent tasks (e.g., 20 at once):

```rust
use tokio::process::Command;
use tokio::time::{sleep, Duration};

async fn test_one() {
    let mut child = Command::new("strace")
        .args("-o /dev/null -D sleep 5".split(' '))
        .spawn()
        .unwrap();

    sleep(Duration::from_millis(100)).await;
    unsafe { libc::kill(child.id().unwrap() as _, libc::SIGINT) };

    // This should always complete promptly and return successfully.
    child.wait().await.unwrap();
}
```

Expected behavior: `child.wait().await` should consistently resolve after the signal is delivered, and the awaited task should complete successfully. Running many instances in parallel should not deadlock, hang indefinitely, or spuriously error.

Actual behavior: under concurrent load, after sending `SIGINT` to the spawned process (using `child.id()` and `libc::kill`), `child.wait().await` can fail to complete reliably (hangs) and/or return an unexpected error, indicating Tokio’s child-process reaping/notification logic is not correctly handling this interrupt-and-wait scenario.

Fix the process management so that waiting on a signaled child process is reliable under concurrency on Linux. The solution should ensure that `tokio::process::Command::spawn`, `Child::id`, and `Child::wait` interoperate correctly with externally delivered signals (like `SIGINT`) so the wait future is always woken and completes once the child exits.