#!/bin/bash

cd /app/src

# Set environment variables (enable nightly tests with thiserror_nightly_testing cfg)
export RUSTFLAGS="-Dwarnings -Adead-code -Arenamed-and-removed-lints --cfg=thiserror_nightly_testing"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_backtrace.rs" "tests/test_backtrace.rs"
mkdir -p "tests"
cp "/tests/test_option.rs" "tests/test_option.rs"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Run the specific tests for this PR
cargo test --test test_backtrace --test test_option
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
