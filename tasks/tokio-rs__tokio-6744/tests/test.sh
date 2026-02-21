#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/task.rs" "tokio/src/runtime/tests/task.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/macros_join.rs" "tokio/tests/macros_join.rs"

# Run the macros_join test with timeout
timeout 300 cargo test --test macros_join -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
