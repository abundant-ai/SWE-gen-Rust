#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-buffer/tests"
cp "/tests/tower-buffer/tests/buffer.rs" "tower-buffer/tests/buffer.rs"

# Run the specific integration test for this PR
cargo test -p tower-buffer --test buffer -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
