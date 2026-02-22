#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "src/combinator"
cp "/tests/src/combinator/tests.rs" "src/combinator/tests.rs"

# Run the specific test file from the PR
cargo test combinator::tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
