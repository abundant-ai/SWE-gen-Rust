#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/conflict"
cp "/tests/test_suite/tests/compile-fail/conflict/flatten-within-enum.rs" "test_suite/tests/compile-fail/conflict/flatten-within-enum.rs"

# Add HashMap import to avoid modern Rust checking HashMap before the macro panic
sed -i '10a\\nuse std::collections::HashMap;' test_suite/tests/compile-fail/conflict/flatten-within-enum.rs

# Build the deps crate first (required for compiletest to find serde_derive)
cd /app/src/test_suite/deps
cargo build

# Run the specific compile-fail test using compiletest with filter
cd /app/src/test_suite

# Set TESTNAME to filter to only the specific test file we want
export TESTNAME=flatten-within-enum

# Run the compile-fail test with the unstable feature (required for compiletest)
cargo test --test compiletest --features unstable compile_fail
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
