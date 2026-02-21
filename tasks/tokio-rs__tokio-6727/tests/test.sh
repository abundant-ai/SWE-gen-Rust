#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests/tracing-instrumentation/tests"
cp "/tests/tokio/tests/tracing-instrumentation/tests/sync.rs" "tokio/tests/tracing-instrumentation/tests/sync.rs"
cp "/tests/tokio/tests/tracing-instrumentation/tests/time.rs" "tokio/tests/tracing-instrumentation/tests/time.rs"

# Remove task.rs to avoid compilation errors (not part of this PR)
rm -f "tokio/tests/tracing-instrumentation/tests/task.rs"

# The Oracle agent applied fix.patch to the main tokio source files
# Rebuild the main tokio package with the fixed source code
cd tokio
cargo build --features full
cd ..

# Run only the specific test files for this PR (sync and time)
# The tracing-instrumentation is a separate package in tokio/tests/tracing-instrumentation/
cd tokio/tests/tracing-instrumentation
# Run both sync and time tests. Both must pass for success.
timeout 300 cargo test --test sync -- --nocapture
sync_status=$?
timeout 300 cargo test --test time -- --nocapture
time_status=$?

# Both tests must pass
if [ $sync_status -eq 0 ] && [ $time_status -eq 0 ]; then
    test_status=0
else
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
