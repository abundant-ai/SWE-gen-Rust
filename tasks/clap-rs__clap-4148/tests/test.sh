#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/default_vals.rs" "tests/builder/default_vals.rs"
mkdir -p "tests/builder"
cp "/tests/builder/require.rs" "tests/builder/require.rs"

# Run tests for the specific files modified in this PR
# Tests are in: tests/builder/{default_vals,require}.rs
cargo test --test builder -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
