The browser-based example check for the `wasm-audio-worklet` example is unreliable and currently fails/flakes because the harness waits for “network idle” instead of waiting for a deterministic signal that the page and worklet are actually initialized. This can hide asynchronous failures (uncaught promise rejections, worklet/module-load errors) until after the test has already moved on, and more recently it causes the `wasm-audio-worklet` scenario to fail.

When loading the `wasm-audio-worklet` example page in an automated Chromium session, the run should reliably fail immediately if the page logs an error (console `error`) or throws an uncaught exception/UnhandledPromiseRejection, and it should reliably proceed only once the example has completed its initialization.

Right now, the run can:
- incorrectly pass while async errors occur after the “network idle” condition is met, or
- incorrectly fail/flakes because the worklet initialization continues after “network idle” and the harness doesn’t wait for a real readiness event.

Implement a deterministic readiness signal for examples (including `wasm-audio-worklet`) so the harness can wait for that signal instead of relying on network-idle heuristics. The readiness signal must be simple enough not to reduce the readability of the examples (e.g., a minimal `console.log` marker or similarly lightweight event), but it must be emitted only after the example is actually ready (including successful worklet/module initialization). If initialization fails, the run should fail with a clear error rather than hanging or passing silently.

Expected behavior:
- Loading the `wasm-audio-worklet` page results in a clear “ready” signal only after the audio worklet and wasm module have initialized successfully.
- Any console error, uncaught exception, or unhandled rejection during initialization causes the run to fail.
- The harness no longer relies on “network idle” as the primary completion criterion for these examples.

Actual behavior:
- The harness relies on “network idle”, which can miss or delay async failures.
- The `wasm-audio-worklet` example fails/flakes because initialization isn’t synchronized with the harness’ completion condition.