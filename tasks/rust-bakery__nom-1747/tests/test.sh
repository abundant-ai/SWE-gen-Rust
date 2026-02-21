#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "src/bytes"
cp "/tests/src/bytes/tests.rs" "src/bytes/tests.rs"
mkdir -p "tests"
cp "/tests/issues.rs" "tests/issues.rs"

# Run the specific test files
# For src/bytes/tests.rs (unit tests in the bytes module) - run tests in bytes::tests
# For tests/issues.rs (integration test that requires alloc feature)
cargo test --lib bytes::tests --features alloc -- --nocapture && \
cargo test --test issues --features alloc -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
