#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/build_dir.rs" "tests/testsuite/build_dir.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/build_dir_legacy.rs" "tests/testsuite/build_dir_legacy.rs"

# Run specific tests from the PR
# Tests: build_dir and build_dir_legacy
cargo test -p cargo --test testsuite build_dir -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
