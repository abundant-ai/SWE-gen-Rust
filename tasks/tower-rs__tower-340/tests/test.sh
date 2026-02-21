#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower/tests"
cp "/tests/tower/tests/builder.rs" "tower/tests/builder.rs"

# Run the specific integration test for this PR
# For Rust integration tests, the test name is the filename without .rs extension
cargo test --test builder --all-features -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
