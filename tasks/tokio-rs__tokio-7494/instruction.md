On Linux, using `tokio::process::Command` with `Child::wait()` can sporadically panic when pidfd-based reaping is in use. The panic message observed is:

`pidfd is ready to read, the process should have exited`

This happens in real workloads that spawn a child process, send it a signal shortly after (e.g. `SIGINT`), and then await `Child::wait()`. The failure can be intermittent and is easier to reproduce under concurrency (many tasks spawning and waiting on processes at the same time).

Reproduction scenario:
- Spawn a process via `tokio::process::Command::new(...).spawn()` (for example, launching `strace -o /dev/null -D sleep 5`).
- After a short delay (e.g. ~100ms), send the child a signal (e.g. `libc::kill(child.id().unwrap() as _, libc::SIGINT)` on Linux).
- Await `child.wait().await`.
- Run many instances concurrently (e.g. 20 tasks) to amplify the race.

Expected behavior: `Child::wait()` should reliably resolve to an exit status (or an I/O error) without panicking, even if the child receives a signal shortly after spawning and even when many waits happen concurrently.

Actual behavior: Tokio can panic with the above message when the pidfd becomes readable even though the process has not yet fully transitioned to a state where Tokio believes it “should have exited”.

Fix the pidfd reaping/wakeup logic so that readiness on the pidfd never triggers a panic in this situation. Instead, the implementation should tolerate spurious/early pidfd readability and ensure `Child::wait()` continues waiting or correctly completes based on the child’s actual state. The corrected behavior must hold under concurrent spawns/signals/waits on Linux.