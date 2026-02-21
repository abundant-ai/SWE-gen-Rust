#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-limit/tests"
cp "/tests/tower-limit/tests/concurrency.rs" "tower-limit/tests/concurrency.rs"
mkdir -p "tower-limit/tests"
cp "/tests/tower-limit/tests/rate.rs" "tower-limit/tests/rate.rs"
mkdir -p "tower-test/tests"
cp "/tests/tower-test/tests/mock.rs" "tower-test/tests/mock.rs"

# Run the specific integration tests for this PR
# For Rust integration tests, the test name is the filename without .rs extension
cargo test --test concurrency --test rate --test mock --all-features -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
