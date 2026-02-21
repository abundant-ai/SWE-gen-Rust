#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-buffer/tests"
cp "/tests/tower-buffer/tests/buffer.rs" "tower-buffer/tests/buffer.rs"

# Run specific test that verifies the worker-drop fix
# This test should PASS in the fixed state and FAIL/PANIC in the buggy state
# (response_future_when_worker_is_dropped_early hangs even in fixed state due to modern Rust/Tokio compat issues)
cargo test --test buffer --manifest-path tower-buffer/Cargo.toml poll_ready_when_worker_is_dropped_early
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
