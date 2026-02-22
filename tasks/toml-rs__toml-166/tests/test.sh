#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-key-dotted-into-std.toml" "tests/fixtures/invalid/duplicate-key-dotted-into-std.toml"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-key-std-into-dotted.toml" "tests/fixtures/invalid/duplicate-key-std-into-dotted.toml"
mkdir -p "tests"
cp "/tests/test_invalid.rs" "tests/test_invalid.rs"

# Rebuild tests after copying new test files
cargo build --workspace --all-targets 2>&1

# Run the specific test from the PR
cargo test --test test_invalid 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
