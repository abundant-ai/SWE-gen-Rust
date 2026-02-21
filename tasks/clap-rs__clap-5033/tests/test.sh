#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/error.rs" "tests/builder/error.rs"
mkdir -p "tests/builder"
cp "/tests/builder/subcommands.rs" "tests/builder/subcommands.rs"

# Run the specific tests from builder module
output=$(cargo test --test builder --no-fail-fast -- error:: subcommands:: --nocapture 2>&1)
test_status=$?
echo "$output"

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
