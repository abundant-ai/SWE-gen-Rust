#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "src/bytes"
cp "/tests/src/bytes/tests.rs" "src/bytes/tests.rs"

# Run specific tests for binary digit support in the bytes module
# These tests verify the new bin_digit functionality
cargo test --lib bytes::tests --features alloc -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
