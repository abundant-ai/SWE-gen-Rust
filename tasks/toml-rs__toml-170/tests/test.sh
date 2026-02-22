#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/encoder_compliance.rs" "tests/encoder_compliance.rs"
mkdir -p "tests"
cp "/tests/test_edit.rs" "tests/test_edit.rs"

# Run the specific tests from the PR
cargo test --test encoder_compliance -- --nocapture 2>&1
encoder_status=$?

cargo test --test test_edit -- --nocapture 2>&1
edit_status=$?

# Both tests must pass
if [ $encoder_status -eq 0 ] && [ $edit_status -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
