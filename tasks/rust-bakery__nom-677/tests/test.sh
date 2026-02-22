#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/custom_errors.rs" "tests/custom_errors.rs"
mkdir -p "tests"
cp "/tests/inference.rs" "tests/inference.rs"
mkdir -p "tests"
cp "/tests/issues.rs" "tests/issues.rs"
mkdir -p "tests"
cp "/tests/json.rs" "tests/json.rs"
mkdir -p "tests"
cp "/tests/overflow.rs" "tests/overflow.rs"

# Run the specific test files for this PR
cargo test --test custom_errors --test inference --test issues --test json --test overflow --features "alloc regexp_macros" -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
