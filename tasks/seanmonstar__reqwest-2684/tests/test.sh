#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/ci.rs" "tests/ci.rs"
mkdir -p "tests"
cp "/tests/proxy.rs" "tests/proxy.rs"
mkdir -p "tests/support"
cp "/tests/support/error.rs" "tests/support/error.rs"
mkdir -p "tests/support"
cp "/tests/support/mod.rs" "tests/support/mod.rs"
mkdir -p "tests/support"
cp "/tests/support/server.rs" "tests/support/server.rs"

# Run specific integration tests for this PR
cargo test --test ci --test proxy -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
