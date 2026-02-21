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
cp "/tests/tokio/src/runtime/tests/mod.rs" "tokio/src/runtime/tests/mod.rs"
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/queue.rs" "tokio/src/runtime/tests/queue.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_metrics.rs" "tokio/tests/rt_metrics.rs"

# Run the specific rt_metrics integration test and runtime module tests
cd tokio
timeout 300 cargo test --test rt_metrics --features full -- --nocapture
test_status=$?

# Also run the runtime module unit tests
if [ $test_status -eq 0 ]; then
  timeout 300 cargo test --lib --features full runtime::tests -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
