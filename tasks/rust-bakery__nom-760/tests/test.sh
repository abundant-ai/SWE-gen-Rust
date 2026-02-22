#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/issue_759.rs" "tests/issue_759.rs"

# Run the specific test file for this PR
cargo test --test issue_759 -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
