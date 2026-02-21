#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/tests.rs" "tests/tests.rs"

# Rebuild the project to pick up any source code changes from fix.patch
cargo build --tests

# Run only the specific test(s) for this PR
cargo test --test integration feature_740_passthru -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
