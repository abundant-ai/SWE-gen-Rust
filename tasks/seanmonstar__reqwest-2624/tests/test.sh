#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/not_tcp.rs" "tests/not_tcp.rs"
mkdir -p "tests/support"
cp "/tests/support/mod.rs" "tests/support/mod.rs"
cp "/tests/support/not_tcp.rs" "tests/support/not_tcp.rs"

# Run specific integration test for this PR
cargo test --test not_tcp -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
