#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/inject.rs" "tokio/src/runtime/tests/inject.rs"
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/loom_queue.rs" "tokio/src/runtime/tests/loom_queue.rs"
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/queue.rs" "tokio/src/runtime/tests/queue.rs"

# Run the specific runtime tests
cd tokio
timeout 300 cargo test --lib runtime::tests --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
