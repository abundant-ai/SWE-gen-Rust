#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings --cfg tokio_unstable --cfg loom"
export RUST_BACKTRACE=1
export LOOM_MAX_PREEMPTIONS=2

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/loom_current_thread.rs" "tokio/src/runtime/tests/loom_current_thread.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_handle.rs" "tokio/tests/rt_handle.rs"

# Run loom tests for the specific test
cd tokio
cargo test --lib loom_current_thread::drop_jh_during_schedule --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
