#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/option.rs" "tracing-subscriber/tests/option.rs"

# Rebuild tests after copying new test files (Rust is compiled)
cargo build --workspace --tests

# Run tests for the specific test files from this PR
cargo test -p tracing-subscriber --test option -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
