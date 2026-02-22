#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/intersperse.rs" "tests/intersperse.rs"
mkdir -p "tests"
cp "/tests/producer_split_at.rs" "tests/producer_split_at.rs"

# Run the specific test files from the PR
cargo test --test intersperse -- --nocapture && \
cargo test --test producer_split_at -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
