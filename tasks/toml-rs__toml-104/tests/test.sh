#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_edit.rs" "tests/test_edit.rs"
mkdir -p "tests"
cp "/tests/test_invalid.rs" "tests/test_invalid.rs"
mkdir -p "tests"
cp "/tests/test_parse.rs" "tests/test_parse.rs"
mkdir -p "tests"
cp "/tests/test_valid.rs" "tests/test_valid.rs"

# Rebuild tests after copying test files
cargo build --workspace --all-targets 2>&1

# Run the specific test files for this PR
cargo test --test test_edit 2>&1 && \
cargo test --test test_invalid 2>&1 && \
cargo test --test test_parse 2>&1 && \
cargo test --test test_valid 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
