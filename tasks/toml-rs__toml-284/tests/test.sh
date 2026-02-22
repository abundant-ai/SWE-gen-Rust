#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/enum_external_deserialize.rs" "tests/enum_external_deserialize.rs"
mkdir -p "tests"
cp "/tests/serde.rs" "tests/serde.rs"

# Run the specific tests for this PR (both require the 'easy' feature)
cargo test --test enum_external_deserialize --features easy -- --nocapture 2>&1 && cargo test --test serde --features easy -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
