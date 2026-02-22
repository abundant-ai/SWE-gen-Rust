#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-keys-dotted.stderr" "tests/fixtures/invalid/duplicate-keys-dotted.stderr"

# Run the specific test for this PR (test_invalid runs all fixtures in tests/fixtures/invalid/)
cargo test --test test_invalid -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
