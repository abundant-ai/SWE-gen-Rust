#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"
export MIRIFLAGS="-Zmiri-disable-isolation"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/queue.rs" "tokio/src/runtime/tests/queue.rs"

# Run the stress1 test under Miri to detect undefined behavior
# The buggy version will fail with a stacked borrows error
cd tokio
timeout 600 cargo +nightly miri test --features full --lib --no-fail-fast runtime::tests::queue::stress1 -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
