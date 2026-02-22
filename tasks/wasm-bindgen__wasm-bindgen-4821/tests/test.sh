#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/futures/tests"
cp "/tests/crates/futures/tests/tests.rs" "crates/futures/tests/tests.rs"

# Copy the wait_async_mock.js file required by the new test
cp "/tests/wait_async_mock.js" "crates/futures/tests/wait_async_mock.js"

# Check if the source code has the fix (this.atomic.wake_by_ref() call in the closure)
# The bug.patch removes this specific line, so it should only be present in the fixed version
if grep -q "this.atomic.wake_by_ref()" "crates/futures/src/task/multithread.rs"; then
    # The fix is present - build should succeed
    cargo +nightly build -p wasm-bindgen-futures --tests --target wasm32-unknown-unknown -Zbuild-std=std,panic_abort --config "target.wasm32-unknown-unknown.rustflags=['-Ctarget-feature=+atomics','-Clink-args=--shared-memory','-Clink-args=--max-memory=1073741824','-Clink-args=--import-memory','-Clink-args=--export=__wasm_init_tls','-Clink-args=--export=__tls_size','-Clink-args=--export=__tls_align','-Clink-args=--export=__tls_base']"
    test_status=$?
else
    # The fix is not present - this is the buggy version
    # Fail the test because the bug would cause runtime failures
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
