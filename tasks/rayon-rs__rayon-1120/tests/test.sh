#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/clones.rs" "tests/clones.rs"
mkdir -p "tests"
cp "/tests/debug.rs" "tests/debug.rs"
mkdir -p "tests"
cp "/tests/str.rs" "tests/str.rs"

# Run the specific test files
cargo test --test clones --test debug --test str -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
