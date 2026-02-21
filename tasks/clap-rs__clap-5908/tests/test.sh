#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/arg_matches.rs" "tests/builder/arg_matches.rs"

# Run specific tests from the modified test file
# Test is in: tests/builder/arg_matches.rs
# The 'builder' is the test target that includes this file
cargo test --test builder --features help,usage,error-context,derive -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
