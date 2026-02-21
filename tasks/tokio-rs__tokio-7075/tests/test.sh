#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings --cfg tokio_unstable"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-util/tests"
cp "/tests/tokio-util/tests/task_join_map.rs" "tokio-util/tests/task_join_map.rs"

# Run tests for the task_join_map test file
cd tokio-util
cargo test --test task_join_map --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
