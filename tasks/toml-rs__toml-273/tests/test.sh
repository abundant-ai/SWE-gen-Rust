#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/easy_encoder.rs" "tests/easy_encoder.rs"
mkdir -p "tests"
cp "/tests/encoder.rs" "tests/encoder.rs"
mkdir -p "tests"
cp "/tests/test_parse.rs" "tests/test_parse.rs"

# Run the specific test files from the PR
cargo test --test easy_encoder --test encoder --test test_parse -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
